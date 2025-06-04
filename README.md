# BlueStream

A custom Fedora Silverblue image built on top of bootc-based Fedora Silverblue with RPM Fusion (free & nonfree) and Terra repositories enabled. Optimized for developers and power users with additional tools and multimedia support.

[![Build](https://github.com/yasershahi/bluestream/actions/workflows/build.yml/badge.svg)](https://github.com/yasershahi/bluestream/actions/workflows/build.yml)

## Features

- 🛠️ **Developer Tools**
  - VS Code
  - Docker & Podman with Compose
  - Distrobox
  - DevPod
  - Android Tools & Scrcpy
  - Neovim
  - tmux

- 🎥 **Multimedia Support**
  - FFmpeg with all codecs
  - Hardware acceleration for Intel GPUs
  - GStreamer plugins
  - HEIF support

- 🔧 **System Utilities**
  - Fish shell
  - fastfetch
  - lm_sensors
  - p7zip & unrar
  - Tailscale

- 🌐 **Web Browsers**
  - Brave Browser

## Rebase to BlueStream

### Quick Start (Unsigned)

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/yasershahi/bluestream:latest
```

### Verified Rebase (Recommended)

```bash
# Import signing key
curl -O https://raw.githubusercontent.com/yasershahi/bluestream/main/cosign.pub
sudo mkdir -p /etc/pki/containers
sudo mv cosign.pub /etc/pki/containers/bluestream.pub

# Rebase to signed image
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/yasershahi/bluestream:latest

# After the rebase, reboot the system
systemctl reboot
```

## Verification

The image is signed with Cosign. You can verify the signature using:

```bash
cosign verify --key cosign.pub ghcr.io/yasershahi/bluestream:latest
```

## Pre-configured Features

- RPM Fusion (free & nonfree) repositories
- Terra repository from Fyra Labs
- Hardware video acceleration for Intel GPUs
- Faster boot with NetworkManager wait disabled
- Flathub repository enabled by default
- Common GNOME extensions removed for a cleaner experience
- Optimized systemd timeout settings
