# Docker/Container Hardening Reference

## Critical Checks

```bash
# Running as root?
docker ps --format '{{.Names}}' | while read n; do echo "$n: $(docker exec $n whoami 2>/dev/null)"; done

# Image vulnerabilities
trivy image your-image:latest

# Docker daemon on network? (should return nothing)
ss -tlnp | grep 2375

# Docker socket mounted into containers?
docker inspect $(docker ps -q) | grep -l "docker.sock"
```

## Hardening Actions

1. Run containers as non-root (USER directive in Dockerfile)
2. Drop all capabilities: `cap_drop: ALL`, add back only what's needed
3. Set `security_opt: no-new-privileges:true`
4. Use read-only filesystem: `read_only: true` with tmpfs for /tmp
5. Set resource limits (memory, CPU)
6. Use custom networks — no database ports mapped to host
7. Internal network for databases: `internal: true`
8. Scan images in CI before push (Trivy, Grype, Docker Scout)
9. Pin base image digests, not just tags
10. Multi-stage builds — keep build tools out of production images
11. No secrets in images (use secret managers, mount as files not env vars)
12. Enable Docker content trust

## Mythos Context
Mythos found a guest-to-host escape in a memory-safe VMM. Containers provide less isolation than VMs. Defense in depth: non-root + dropped capabilities + read-only + network isolation + scanned images.
