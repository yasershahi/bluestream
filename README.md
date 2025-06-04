# BlueStream

A custom Fedora Silverblue 42 image built on top of bootc-based Fedora Silverblue with RPM Fusion (free & nonfree) and Terra repositories enabled. Optimized for developers and power users with additional tools and multimedia support.

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

## Before Rebasing

It's recommended to reset rpm-ostree and pin your current deployment before rebasing. This ensures you can return to your current state if needed:

```bash
# View available deployments
rpm-ostree status

# Pin your current deployment (0 is usually the active deployment)
sudo ostree admin pin 0

# Switch to bootc
sudo bootc switch quay.io/fedora/fedora-silverblue:42

# After switch, reboot the system
systemctl reboot
```

## Rebase to BlueStream

### Rebase Command

```bash
sudo bootc switch ghcr.io/yasershahi/bluestream:latest

# After the rebase, reboot the system
systemctl reboot
```

Note: The image is signed with Cosign for security, and bootc handles the verification automatically.

## Pre-configured Features

- RPM Fusion (free & nonfree) repositories
- Terra repository from Fyra Labs
- Hardware video acceleration for Intel GPUs
- Faster boot with NetworkManager wait disabled
- Flathub repository enabled by default
- Common GNOME extensions removed for a cleaner experience
- Optimized systemd timeout settings

## Disclaimer

Fedora® is a registered trademark of Red Hat, Inc. This project is not affiliated with, endorsed by, or sponsored by the Fedora Project or Red Hat, Inc.

This image is provided "as is" without warranty of any kind, either express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability arising from, out of, or in connection with the image or the use or other dealings in the image.

The user assumes all responsibility for the use of this image, including but not limited to:
- Backing up data before use
- Testing compatibility with their hardware and use case
- Understanding that this is a community project and comes with no warranties or guarantees