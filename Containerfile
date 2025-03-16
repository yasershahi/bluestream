ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

# Add RPM Fusion
RUN dnf install -y gcc make libxcrypt-compat
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Additional Packages
RUN dnf install -y \
	aria2 \
	adcli \
	bat \
	bcc \
	btop \
	cloudflare-warp \
	code \
	curl \
	dnf-utils \
	duf \
	eza \
	fastfetch \
	ffmpegthumbnailer \
	fish \
	firewall-config \
	fuse-encfs \
	fzf \
	gh \
	git-credential-oauth \
	gnome-themes-extra \
	gnome-tweaks \
	google-noto-fonts-all \
	gvfs-nfs \
	heif-pixbuf-loader \
	htop \
	httpie \
	iftop \
	ifuse \
	ibm-plex-mono-fonts \
	iotop \
	jq \
	libimobiledevice \
	libsss_autofs \
	libxcrypt-compat \
	lm_sensors \
	net-tools \
	nmap \
	neovim \
	nss-tools \
	p7zip \
	p7zip-plugins \
	pipx \
	procs \
	scrcpy \
	screen \
	showtime \
	strace \
	sstp-client \
	NetworkManager-sstp \
	NetworkManager-sstp-gnome \
	subversion \
	tailscale \
	telegram-desktop \
	tldr \
	tmux \
	traceroute \
	tokei \
	unrar \
	ungoogled-chromium \
	wl-clipboard \
	yt-dlp \
	zstd

# Patch Mutter
RUN dnf reinstall -y mutter --repo copr:copr.fedorainfracloud.org:execat:mutter-performance

# Codecs
RUN dnf install -y --allowerasing \
        ffmpeg \
        gstreamer1-plugin-libav \
        gstreamer1-plugins-bad-free-extras \
        gstreamer1-plugins-bad-freeworld \
        gstreamer1-plugins-ugly \
        gstreamer1-vaapi \
        mesa-va-drivers-freeworld \
        mesa-vdpau-drivers-freeworld \
        libva-intel-driver

# H/W Video Acceleration
RUN dnf install -y \
	ffmpeg-libs \
	libva \
	libva-utils \
	openh264 \
	gstreamer1-plugin-openh264 \
	mozilla-openh264

RUN dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Cleanup & Finalize
RUN rm -rf /tmp/* /var/*
RUN rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo && \
    rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm -f /etc/yum.repos.d/execat-mutter-performance.repo && \
    rm -f /etc/yum.repos.d/github.repo && \
    rm -f /etc/yum.repos.d/vscode.repo && \
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


