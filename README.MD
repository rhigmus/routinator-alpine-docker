# Routinator Alpine Docker

**Lightweight, Dockerized Routinator build using Alpine — designed for secure, repeatable deployments with custom config and certs.**

---

## Overview

This project provides a minimal Alpine-based Docker container for [Routinator](https://nlnetlabs.nl/projects/rpki/routinator/), built via multi-stage Docker builds. It supports running with user-supplied TLS certificates and Routinator configuration files.

---

## Features

- Multi-stage build with Rust 1.82 and Alpine
- TLS support via mounted PEM certificate/key files
- Clean, repeatable setup with minimal dependencies
- `host` networking mode for direct network stack integration

---

## Prerequisites

- Linux system with Docker & Docker Compose installed
- Basic familiarity with `docker` and `systemd`
- Host must be able to run containers in host network mode

### 1. Install Docker

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker
```

### 2. Optional: Redirect Docker's build path (if root disk is small)

```bash
sudo mkdir -p /srv/docker
sudo systemctl stop docker
sudo mkdir -p /etc/docker
echo '{ "data-root": "/srv/docker" }' | sudo tee /etc/docker/daemon.json
sudo systemctl daemon-reexec
sudo systemctl start docker
```

---

## Project Structure

```
.
├── docker-compose.yml
├── Dockerfile
└── routinator_config_store/
    ├── routinator.conf
    ├── certs/
        ├── routinator.crt
        └── routinator.key
```

---

## Configuration

- `routinator.conf`: Your Routinator configuration file
- `certs/`: Must contain `routinator.crt` and `routinator.key` PEM files
- `docker-compose.yml` uses `network_mode: "host"` to expose services directly on the host

---

## Build & Run

```bash
docker compose build --no-cache
docker compose up -d
```

---

## Firewall Configuration

If `firewalld` is active, run the following:

```bash
sudo firewall-cmd --permanent --add-port=8323/tcp
sudo firewall-cmd --permanent --add-port=3323/tcp
sudo firewall-cmd --reload
```

---

## Troubleshooting

### View Logs

```bash
docker logs routinator
```

### Test Connectivity

```bash
curl -k https://10.10.51.20:8323/status
```

---

## License

MIT — use at your own risk. No warranties expressed or implied.