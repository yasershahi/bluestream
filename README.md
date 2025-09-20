# BlueStream
[![Build](https://github.com/yasershahi/bluestream/actions/workflows/build.yml/badge.svg)](https://github.com/yasershahi/bluestream/actions/workflows/build.yml)

> **Important:**  
> This custom Fedora Silverblue Bootc image is provided as an example only. Feel free to fork and customize for your own use!

## Rebasing

It's recommended to reset rpm-ostree and pin the current deployment before rebasing.

```bash
# View available deployments
rpm-ostree status

# Pin your current deployment (0 is usually the active deployment)
sudo ostree admin pin 0

# Switch to bootc
sudo bootc switch quay.io/fedora/fedora-silverblue:43

# After switch, reboot the system
systemctl reboot
```

Then

```bash
# Optional: Verify image signature before switching (recommended)
cosign verify --key cosign.pub ghcr.io/yasershahi/bluestream:43

# Switch to BlueStream
sudo bootc switch ghcr.io/yasershahi/bluestream:43

# After the rebase, reboot the system
systemctl reboot
```


## Customizations

* Disabled NetworkManager-wait-online service
* Disabled GNOME Software autostart
* Switched to Flathub repository
* Automatically replace Fedora Flatpak apps with Flathub versions
* Optimized systemd timeout settings

### Additions
* Intel GPU hardware video acceleration via RPM Fusion
* Media Codecs
* Android Tools & Scrcpy
* Virtualization (QEMU/KVM, Incus, EDK2-OVMF)
* Tailscale
* Gnome Themes Extra
* Misc (unrar, nss-tools,...)


## Disclaimer

This project is not affiliated with, endorsed by, or sponsored by the Fedora Project or Red Hat, Inc.