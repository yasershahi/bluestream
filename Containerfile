FROM quay.io/fedora/fedora-silverblue:42

# Copy Files
COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

# Fix /opt directory (by Universal Blue)
RUN set -euo pipefail && \
    mkdir -p /var/opt /usr/lib/opt && \
    for dir in /var/opt/*/; do \
        [ -d "$dir" ] || continue; \
        dirname=$(basename "$dir"); \
        mv "$dir" "/usr/lib/opt/$dirname" || { echo "Failed to move $dir"; exit 1; }; \
        echo "L+ /var/opt/$dirname - - - - /usr/lib/opt/$dirname" >> /usr/lib/tmpfiles.d/opt-fix.conf; \
    done

# Add RPM Fusion repositories and build dependencies
RUN dnf install -y gcc make libxcrypt-compat && \
    dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y terra-release

# System and Developer Tools
RUN dnf install -y \
    android-tools \
    code \
    containerd.io \
    devpod \
    distrobox \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    fastfetch \
    fish \
    gnome-themes-extra \
    gnome-tweaks \
    ifuse \
    lm_sensors \
    neovim \
    nss-tools \
    p7zip \
    p7zip-plugins \
    podman-compose \
    scrcpy \
    tailscale \
    tmux \
    unrar \
    wl-clipboard \
    zstd

# Multimedia
RUN dnf install -y --allowerasing \
    ffmpeg \
    ffmpeg-libs \
    ffmpegthumbnailer \
    gstreamer1-libav \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-vaapi \
    heif-pixbuf-loader

# H/W Video Acceleration
RUN dnf install -y \
    gstreamer1-plugin-openh264 \
    intel-gpu-tools \
    intel-media-driver \
    libva \
    libva-intel-driver \
    libva-utils \
    openh264

# Web Browsers
RUN dnf install -y \
	brave-browser

# Remove Packages
RUN dnf remove -y \
    fedora-workstation-backgrounds \
    firefox \
    firefox-langpacks \
    gcc \
    gnome-classic-session \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-common \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    gnome-software-rpm-ostree \
    gnome-tour \
    make

# Cleanup & Finalize
RUN rm -rf /tmp/* /var/* && \
    rm -f /etc/yum.repos.d/{_copr:copr.fedorainfracloud.org:phracek:PyCharm,fedora-cisco-openh264,github,vscode,chronoscrat-devpod,cloudflare-warp,wojnilowicz-ungoogled-chromium,brave-browser,zeno-scrcpy,docker-ce,terra}.repo && \
    rm -f /etc/yum.repos.d/librewolf.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


