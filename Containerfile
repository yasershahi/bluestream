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
	code \
	containerd.io \
	curl \
	devpod \
	distrobox \
	docker-ce \
	docker-ce-cli \
	docker-buildx-plugin \
	docker-compose-plugin \
	dnf-utils \
	duf \
	eza \
	fastfetch \
	ffmpegthumbnailer \
	fish \
	firewall-config \
	flatpak-builder \
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
	iptables-libs \
	jq \
	libimobiledevice \
	libsss_autofs \
	libxcrypt-compat \
	libnetfilter_conntrack \
	libnfnetlink \
	libnftnl \
	lm_sensors \
	net-tools \
	nmap \
	neovim \
	nftables \
	nss-tools \
	p7zip \
	p7zip-plugins \
	pipx \
	procs \
	podman-compose \
	podman-tui \
	podmansh \
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

# Install Plex Media Server
RUN dnf install -y https://downloads.plex.tv/plex-media-server-new/1.41.5.9522-a96edc606/redhat/plexmediaserver-1.41.5.9522-a96edc606.x86_64.rpm

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
    rm -f /etc/yum.repos.d/chronoscrat-devpod.repo && \
    rm -f /etc/yum.repos.d/wojnilowicz-ungoogled-chromium.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


