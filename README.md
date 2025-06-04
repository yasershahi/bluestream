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
# Optional: Verify image signature before switching (recommended)
cosign verify --key cosign.pub ghcr.io/yasershahi/bluestream:42

# Switch to BlueStream
sudo bootc switch ghcr.io/yasershahi/bluestream:42

# After the rebase, reboot the system
systemctl reboot
```

Note: While bootc doesn't handle signature verification automatically, you can manually verify the image's signature using Cosign before switching. The public key (cosign.pub) is provided in this repository.

## Pre-configured Features

- RPM Fusion (free & nonfree) repositories
- Terra repository from Fyra Labs
- Hardware video acceleration for Intel GPUs
- Faster boot with NetworkManager wait disabled
- Flathub repository enabled by default
- Common GNOME extensions removed for a cleaner experience
- Optimized systemd timeout settings

## Post-install Steps (Optional)

After installing BlueStream, you may want to perform some additional setup for a better experience:

### Docker Setup
Docker is provided in this image, but you need to perform a few steps to enable it for your user:

1. **Create the docker group (if it doesn't exist):**
   ```sh
   sudo groupadd docker
   ```
2. **Add your user to the docker group:**
   ```sh
   sudo usermod -aG docker $USER
   ```
3. **Enable Docker and containerd services:**
   ```sh
   sudo systemctl enable docker.service
   sudo systemctl enable containerd.service
   ```
4. **Apply group changes without rebooting:**
   ```sh
   newgrp docker
   ```
After these steps, you should be able to use Docker as your regular user without sudo.

### Change Default Shell to Fish
Fish shell is included in this image. If you wish to use it as your default shell, follow these steps:

1. **Run fish for the first time:**
   ```sh
   fish
   ```
2. **Locate the installed path:**
   ```sh
   which fish
   # Should output: /usr/sbin/fish
   ```
3. **Add fish to /etc/shells (if not already present):**
   ```sh
   echo /usr/sbin/fish | sudo tee -a /etc/shells
   ```
4. **Change your default shell to fish:**
   ```sh
   chsh -s /usr/sbin/fish
   ```
5. **Reopen your terminal. To disable the Fish welcome message:**
   ```sh
   nano ~/.config/fish/config.fish
   ```
   Add this line to the file:
   ```sh
   set -g fish_greeting ""
   ```
You may need to log out and log back in for the shell change to take effect.

### (Optional) Enhance Your Fish Shell with Starship Prompt

1. **Install a Nerd Font** (required for best Starship experience):
   - Download and install a font like JetBrainsMono from [Nerd Fonts](https://www.nerdfonts.com/).

2. **Install Starship prompt:**
   ```sh
   curl -sS https://starship.rs/install.sh | sh
   ```

3. **Configure Fish shell to initialize Starship:**
   ```sh
   nano ~/.config/fish/config.fish
   ```
   Add this line to the end of the file:
   ```sh
   starship init fish | source
   ```

4. **(Optional) Use a Starship preset:**
   - See available [Starship presets](https://starship.rs/presets/)
   - Example (Pure preset):
     ```sh
     starship preset pure-preset -o ~/.config/starship.toml
     ```

After these steps, your Fish shell will have a beautiful, fast, and informative prompt!

## Disclaimer

Fedora® is a registered trademark of Red Hat, Inc. This project is not affiliated with, endorsed by, or sponsored by the Fedora Project or Red Hat, Inc.

This image is provided "as is" without warranty of any kind, either express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability arising from, out of, or in connection with the image or the use or other dealings in the image.

The user assumes all responsibility for the use of this image, including but not limited to:
- Backing up data before use
- Testing compatibility with their hardware and use case
- Understanding that this is a community project and comes with no warranties or guarantees