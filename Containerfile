ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

# Copy Files
COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

# Fix /opt directory by ublue project
RUN set -euo pipefail && \
    echo "=== Starting /opt directory fix ===" && \
    mkdir -p /var/opt /usr/lib/opt && \
    for dir in /var/opt/*/; do \
        [ -d "$dir" ] || continue; \
        dirname=$(basename "$dir"); \
        mv "$dir" "/usr/lib/opt/$dirname" || { echo "Failed to move $dir"; exit 1; }; \
        echo "L+ /var/opt/$dirname - - - - /usr/lib/opt/$dirname" >> /usr/lib/tmpfiles.d/opt-fix.conf; \
    done && \
    echo "=== Fix completed ==="

# Add RPM Fusion
RUN dnf install -y gcc make libxcrypt-compat
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Remove Packages
RUN dnf remove -y \
	gnome-shell-extension-common \
	gnome-shell-extension-apps-menu \
	gnome-shell-extension-launch-new-instance \
	gnome-shell-extension-places-menu \
	gnome-shell-extension-window-list \
	gnome-shell-extension-background-logo \
	gnome-tour \
	gnome-software-rpm-ostree \
	gnome-classic-session \
	f41-backgrounds-gnome

# Additional System Packages
RUN dnf install -y \
	aria2 \
	adcli \
	bat \
	btop \
	curl \
	dnf-utils \
	duf \
	eza \
	fastfetch \
	fish \
	fuse-encfs \
	fzf \
	gnome-themes-extra \
	gnome-tweaks \
	gvfs-nfs \
	htop \
	ifuse \
	iotop \
	jq \
	libimobiledevice \
	libsss_autofs \
	libnetfilter_conntrack \
	libnfnetlink \
	libnftnl \
	lm_sensors \
	nss-tools \
	p7zip \
	p7zip-plugins \
	procs \
	screen \
	strace \
	tldr \
	tmux \
	tokei \
	unrar \
	wl-clipboard \
	yt-dlp \
	zstd

# Developer Tools
RUN dnf install -y \
	bcc \
	code \
	devpod \
	distrobox \
	gh \
	git \
	git-credential-oauth \
	neovim \
	pipx \
	podman-compose \
	podmansh \
	scrcpy \
	subversion

# Web Browsers
RUN dnf install -y \
	ungoogled-chromium

# Networking Tools
RUN dnf install -y \
	cloudflare-warp \
	firewall-config \
	httpie \
	iftop \
	iptables-libs \
	nmap \
	net-tools \
	nftables \
	nss-tools \
	NetworkManager-sstp \
	NetworkManager-sstp-gnome \
	sstp-client \
	tailscale \
	traceroute

# H/W Video Acceleration
RUN dnf install -y \
	gstreamer1-plugin-openh264 \
	libva \
        libva-intel-driver \
	libva-utils \
	mesa-va-drivers-freeworld \
	mesa-vdpau-drivers-freeworld \
	mozilla-openh264 \
	openh264

RUN dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Multimedia
RUN dnf install -y --allowerasing \
	ffmpeg \
	ffmpeg-libs \
	ffmpegthumbnailer \
	gstreamer1-libav \
        gstreamer1-plugins-bad-freeworld \
        gstreamer1-plugins-ugly \
        gstreamer1-vaapi \
	heif-pixbuf-loader \
	mpv \
	showtime

# Patch Mutter
RUN dnf reinstall -y mutter --repo copr:copr.fedorainfracloud.org:execat:mutter-performance

# Cleanup & Finalize
RUN rm -rf /tmp/* /var/*
RUN rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo && \
    rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm -f /etc/yum.repos.d/execat-mutter-performance.repo && \
    rm -f /etc/yum.repos.d/github.repo && \
    rm -f /etc/yum.repos.d/vscode.repo && \
    rm -f /etc/yum.repos.d/chronoscrat-devpod.repo && \
    rm -f /etc/yum.repos.d/cloudflare-warp.repo && \
    rm -f /etc/yum.repos.d/wojnilowicz-ungoogled-chromium.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


