# Routinator Alpine Docker

A lightweight, containerized deployment of NLnet Labs’ Routinator built using Alpine Linux and Docker.

---

## 🚀 Overview

This project packages Routinator into a multi-stage Alpine-based Docker container. It supports:

- Minimal image footprint for production use.
- Host networking with custom certificate support.
- Mounted configuration and certificate directories for portability.
- Repeatable builds with configuration persisted outside the container.

---

## 📁 Project Structure

```text
.
├── Dockerfile                  # Multi-stage Docker build
├── docker-compose.yml         # Host-mode container orchestration
├── routinator_config_store/
│   ├── routinator.conf        # Primary Routinator config file
│   └── certs/
│       ├── routinator.crt     # TLS certificate (provided by user)
│       └── routinator.key     # TLS private key (provided by user)
```

---

## 🔧 Prerequisites

### Install Docker

<details>
<summary><strong>Ubuntu / Debian</strong></summary>

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
```
</details>

<details>
<summary><strong>CentOS / RHEL / Rocky / Alma</strong></summary>

```bash
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager   --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```
</details>

<details>
<summary><strong>Arch Linux</strong></summary>

```bash
sudo pacman -Syu docker
sudo systemctl enable --now docker
```
</details>

<details>
<summary><strong>Mac (with Homebrew)</strong></summary>

```bash
brew install --cask docker
open /Applications/Docker.app
```
</details>

---

### Install Docker Compose (if needed)

For systems without Compose plugin support (e.g. older distros):

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

---

## 📦 Build & Run

```bash
# (Optional) Relocate Docker build path
sudo mkdir -p /srv/docker
sudo systemctl stop docker
sudo mkdir -p /etc/docker
echo '{ "data-root": "/srv/docker" }' | sudo tee /etc/docker/daemon.json
sudo systemctl daemon-reexec
sudo systemctl start docker

# Clone and build
git clone https://github.com/rhigmus/routinator-alpine-docker.git
cd routinator-alpine-docker

# Copy your TLS cert/key to routinator_config_store/certs/
cp your.crt routinator_config_store/certs/routinator.crt
cp your.key routinator_config_store/certs/routinator.key

# Start container
docker compose up -d --build
```

---

## 🔥 Firewall Configuration

Allow access to the Routinator RTR and HTTPS ports:

```bash
sudo firewall-cmd --permanent --add-port=8323/tcp
sudo firewall-cmd --permanent --add-port=3323/tcp
sudo firewall-cmd --reload
```

---

## 🛠 Troubleshooting

- **Check logs:** `docker logs routinator`
- **Test HTTPs:** `curl -k https://<container-ip>:8323/status`
- **Check config path:** Ensure `routinator.conf` and certs are correctly mounted and readable.
- **Verify container IP:** If not using host networking, check container’s IP and published ports.

---