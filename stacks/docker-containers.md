# Docker and Container Security Hardening Guide

**For teams running containerized applications in the post-Mythos era.**

Containers are not security boundaries by default. A misconfigured container is just a fancy way to run vulnerable software with a false sense of isolation. Mythos found a guest-to-host escape in a memory-safe VMM — container escapes are a real threat.

---

## 1. Image Security

### Use Minimal Base Images

```dockerfile
# BAD: Full OS image with unnecessary attack surface
FROM ubuntu:24.04

# BETTER: Slim variant
FROM python:3.12-slim

# BEST: Distroless or Alpine (minimal packages, minimal attack surface)
FROM gcr.io/distroless/python3-debian12
FROM node:20-alpine
```

### Scan Images for Vulnerabilities

```bash
# Docker Scout (built into Docker Desktop)
docker scout cves your-image:latest

# Trivy (free, comprehensive)
trivy image your-image:latest

# Grype (free, fast)
grype your-image:latest

# Snyk container scan
snyk container test your-image:latest
```

- [ ] Image scanning integrated into CI/CD pipeline (scan on every build)
- [ ] No HIGH or CRITICAL vulnerabilities in production images
- [ ] Base images rebuilt weekly from latest upstream (don't let base image patches go stale)

### Image Hygiene

- [ ] **Pin base image digests**, not just tags (tags can be overwritten)
  ```dockerfile
  # BAD: Tag can change
  FROM node:20-alpine
  
  # GOOD: Pinned digest is immutable
  FROM node:20-alpine@sha256:abc123def456...
  ```
- [ ] **No secrets in images** — not in ENV, not in COPY, not in build args
  ```bash
  # Check image history for leaked secrets
  docker history --no-trunc your-image:latest
  ```
- [ ] **Multi-stage builds** to keep build tools out of production images
  ```dockerfile
  # Build stage
  FROM node:20-alpine AS builder
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci
  COPY . .
  RUN npm run build
  
  # Production stage - only the built output
  FROM node:20-alpine
  WORKDIR /app
  COPY --from=builder /app/dist ./dist
  COPY --from=builder /app/node_modules ./node_modules
  CMD ["node", "dist/index.js"]
  ```
- [ ] **Only install production dependencies** in production images
  ```dockerfile
  RUN npm ci --omit=dev
  ```

---

## 2. Runtime Security

### Don't Run as Root

```dockerfile
# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to non-root user
USER appuser

# Verify
# docker exec container-name whoami
# Should NOT output "root"
```

- [ ] **All production containers run as non-root**
  ```bash
  # Check running containers
  docker ps --format '{{.Names}}' | while read name; do
    user=$(docker exec "$name" whoami 2>/dev/null)
    echo "$name: $user"
  done
  ```

### Drop Capabilities

```yaml
# docker-compose.yml
services:
  app:
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE  # Only if binding to ports below 1024
    read_only: true        # Read-only filesystem
    tmpfs:
      - /tmp               # Writable temp directory if needed
```

### Resource Limits

```yaml
# docker-compose.yml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '1.0'
        reservations:
          memory: 256M
          cpus: '0.5'
```

Without limits, a compromised container can exhaust host resources (DoS).

### Read-Only Filesystem

```yaml
services:
  app:
    read_only: true
    tmpfs:
      - /tmp
      - /var/run
    volumes:
      - app-data:/app/data  # Only specific paths are writable
```

Prevents attackers from writing webshells, downloading tools, or modifying application code.

---

## 3. Network Security

### Don't Expose Ports You Don't Need

```yaml
# BAD: Exposes database to host (and potentially the internet)
services:
  db:
    ports:
      - "5432:5432"

# GOOD: Only accessible from other containers on the same network
services:
  db:
    expose:
      - "5432"
    # No "ports:" mapping
```

### Use Custom Networks

```yaml
# docker-compose.yml
services:
  app:
    networks:
      - frontend
      - backend
  
  db:
    networks:
      - backend  # Database only reachable from backend network
  
  nginx:
    networks:
      - frontend  # Only nginx faces the internet

networks:
  frontend:
  backend:
    internal: true  # No external access at all
```

- [ ] Each service only connects to networks it needs
- [ ] Database and cache containers are on internal-only networks
- [ ] Only the reverse proxy / load balancer has port mappings to the host

---

## 4. Secrets Management

### Never Put Secrets in Images or Environment Variables

```yaml
# BAD: Secret in environment variable (visible in docker inspect)
services:
  app:
    environment:
      - DB_PASSWORD=supersecret

# GOOD: Docker secrets (Swarm) or external secret manager
services:
  app:
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    external: true
```

For non-Swarm environments:
- [ ] Use a secret manager (AWS Secrets Manager, HashiCorp Vault, Doppler)
- [ ] Secrets mounted as files, not environment variables (env vars leak in logs, debug output, /proc)
- [ ] Never pass secrets via `docker build --build-arg` (persisted in image layers)

---

## 5. Docker Daemon Security

- [ ] **Docker daemon not exposed on network** (no `-H tcp://0.0.0.0:2375`)
  ```bash
  # Check if Docker daemon is listening on TCP
  ss -tlnp | grep 2375
  # This should return NOTHING
  ```
- [ ] **Docker socket not mounted into containers** unless absolutely necessary
  ```yaml
  # DANGEROUS: Gives container full control of Docker host
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  ```
- [ ] **Docker content trust enabled** for image verification
  ```bash
  export DOCKER_CONTENT_TRUST=1
  ```
- [ ] **Docker daemon configured with userns-remap** (maps container root to unprivileged host user)
- [ ] **Docker version is current** — check for security updates

---

## 6. Container Orchestration (Docker Compose / Swarm / Kubernetes)

### Docker Compose

```yaml
# Production docker-compose.yml checklist
version: '3.8'
services:
  app:
    image: your-registry/app:specific-tag  # Pinned tag, not :latest
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    read_only: true
    tmpfs:
      - /tmp
    deploy:
      resources:
        limits:
          memory: 512M
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

- [ ] **No `:latest` tags in production** — pin to specific versions
- [ ] **Health checks defined** for all services
- [ ] **Logging limits set** (prevent disk exhaustion from log flooding)
- [ ] **Restart policies configured**

---

## 7. CI/CD Pipeline Security

```yaml
# GitHub Actions: Build, scan, and push
- name: Build image
  run: docker build -t app:${{ github.sha }} .

- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: app:${{ github.sha }}
    severity: CRITICAL,HIGH
    exit-code: 1  # Fail the pipeline on critical/high vulns

- name: Push if clean
  if: success()
  run: docker push your-registry/app:${{ github.sha }}
```

- [ ] Images scanned for vulnerabilities before push to registry
- [ ] Pipeline fails on CRITICAL or HIGH findings
- [ ] Registry uses image signing / content trust
- [ ] Base images rebuilt on a schedule (not just when your code changes)

---

## 8. Mythos-Specific Concerns

Mythos found a guest-to-host escape in a "memory-safe virtual machine monitor." Containers provide less isolation than VMs. Assume:

- Container escapes via kernel exploits are a real threat (Mythos found Linux kernel privesc for under $2,000)
- Image supply chain attacks will increase (trojanized base images, compromised registries)
- AI-assisted attackers will find container misconfigurations faster than you can audit them

**Defense in depth:** Don't rely on the container boundary alone. Run containers as non-root, with dropped capabilities, on read-only filesystems, with network segmentation, and with scanned images. Each layer independently limits damage.

---

## Quick Wins (Do Today)

1. Run `trivy image` or `docker scout cves` on your production images
2. Check if any containers are running as root
3. Check if any database ports are mapped to the host
4. Verify no secrets in `docker history --no-trunc`
5. Add `security_opt: - no-new-privileges:true` to all services
