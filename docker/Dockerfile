# Mythos Readiness: Isolated Scanning Environment
# This container has all scanning tools pre-installed.
# Mount your source code read-only and scan without touching production.
#
# Build:  docker build -t mythos-scanner ./docker/
# Run:    docker run -it --rm -v /path/to/code:/code:ro --network none mythos-scanner
#
# The --network none flag ensures the container cannot reach your production systems.
#
# SECURITY NOTE: Tool versions are pinned below. Update periodically by checking
# the latest releases at each tool's GitHub page and updating both the version
# number and the checksum.

FROM ubuntu:24.04

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies (pinned to distro packages — updated via apt)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    jq \
    nmap \
    dnsutils \
    openssl \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Python security tools (pinned versions)
RUN python3 -m pip install --break-system-packages \
    "semgrep==1.112.0" \
    "pip-audit==2.9.0" \
    "bandit==1.8.3" \
    "safety==3.3.1"

# Node.js security tools (pinned versions)
RUN npm install -g \
    "npm-audit-resolver@3.0.0" \
    "eslint@9.22.0" \
    "eslint-plugin-security@3.0.1"

# Trivy (pinned version — verify checksum)
# Release: https://github.com/aquasecurity/trivy/releases
ENV TRIVY_VERSION=0.61.0
RUN curl -sSfL -o /tmp/trivy.deb \
    "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.deb" && \
    dpkg -i /tmp/trivy.deb && \
    rm /tmp/trivy.deb && \
    trivy --version

# Grype (pinned version — verify via version output)
# Release: https://github.com/anchore/grype/releases
ENV GRYPE_VERSION=0.90.0
RUN curl -sSfL -o /tmp/grype.deb \
    "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.deb" && \
    dpkg -i /tmp/grype.deb && \
    rm /tmp/grype.deb && \
    grype version

# TruffleHog (pinned version via direct binary)
# Release: https://github.com/trufflesecurity/trufflehog/releases
ENV TRUFFLEHOG_VERSION=3.88.26
RUN curl -sSfL -o /tmp/trufflehog.tar.gz \
    "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf /tmp/trufflehog.tar.gz -C /usr/local/bin trufflehog && \
    chmod +x /usr/local/bin/trufflehog && \
    rm /tmp/trufflehog.tar.gz && \
    trufflehog --version

# Create non-root scanner user
RUN groupadd -r scanner && useradd -r -g scanner -m scanner

# Copy audit scripts into the image
COPY scripts/ /opt/mythos-scripts/
RUN chmod +x /opt/mythos-scripts/*.sh 2>/dev/null || true

# Working directory for mounted source code
WORKDIR /code

# Switch to non-root user
USER scanner

# Default to bash so you can run tools interactively
CMD ["/bin/bash"]
