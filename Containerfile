ARG FEDORA_MAJOR_VERSION=41
FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

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
	f41-backgrounds-base \
	fedora-workstation-backgrounds

# Additional System Packages
RUN dnf install -y \
	aria2 \
	adcli \
	bat \
	dnf-utils \
	duf \
	eza \
	fastfetch \
	fish \
	fzf \
	gnome-themes-extra \
	gnome-tweaks \
	gvfs-nfs \
	htop \
	ifuse \
	iotop \
	libxcrypt-compat \
	libsss_autofs \
	lm_sensors \
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
	gcc \
	gh \
	git \
	git-credential-oauth \
	make \
	neovim \
	pipx \
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
	nmap \
	net-tools \
	nss-tools \
	NetworkManager-sstp \
	NetworkManager-sstp-gnome \
	sstp-client \
	tailscale \
	traceroute

# H/W Video Acceleration
RUN dnf install -y --allowerasing \
	intel-vaapi-driver \
	gstreamer1-plugin-openh264 \
	mozilla-openh264 \
	openh264

RUN dnf reinstall -y --allowerasing \
	libva \
	libva-intel-media-driver

# Multimedia
RUN dnf install -y --allowerasing \
	ffmpeg \
	ffmpeg-libs \
	ffmpegthumbnailer \
	gstreamer1-plugin-libva \
	gstreamer1-plugins-bad \
	gstreamer1-plugins-ugly \
	gstreamer1-plugind-vaapi \
	heif-pixbuf-loader \
	mesa-dri-drivers \
	mesa-libEGL \
	mesa-libGL \
	mesa-va-drivers \
	mpv \
	pipewire-libs-extra \
	showtime \
	x264 \
	x265

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
    rm -f /etc/yum.repos.d/fedora-multimedia.repo && \
    rm -f /etc/yum.repos.d/wojnilowicz-ungoogled-chromium.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


