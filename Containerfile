ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

# Copy Files
COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

RUN dnf install -y cloudflare-warp ... > /var/log/dnf_install.log 2>&1 || (cat /var/log/dnf_install.log && exit 1)

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
	libxcrypt-compat \
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
	rar \
	wl-clipboard \
	yt-dlp \
	zstd

# Developer Tools
RUN dnf install -y \
	bcc \
	code \
	devpod \
	distrobox \
	flatpak-builder \
	gcc \
	gh \
	git \
	git-credential-oauth \
	make \
	neovim \
	pipx \
	podman-compose \
	podman-tui \
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
	libproxy-bin \
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
RUN dnf install -y --setopt=install_weak_deps=False \
	gstreamer1-plugin-openh264 \
	intel-vaapi-driver \
	libva \
	libva-intel-media-driver \
	libva-utils \
	mesa-va-drivers \
	mozilla-openh264 \
	openh264

# Multimedia
RUN dnf install -y --allowerasing --setopt=install_weak_deps=False \
	ffmpeg \
	ffmpeg-libs \
	ffmpegthumbnailer \
	flexiblas-openblas-serial \
	HandBrake-cli \
	HandBrake-gui \
	gstreamer1-plugin-libav \
	gstreamer1-plugin-vaapi \
	gstreamer1-plugins-bad \
	gstreamer1-plugins-bad-fluidsynth \
	gstreamer1-plugins-good \
	gstreamer1-plugins-good-extras \
	gstreamer1-plugins-good-gtk \
	gstreamer1-plugins-good-qt6 \
	gstreamer1-plugins-ugly \
	heif-pixbuf-loader \
	mkvtoolnix \
	mkvtoolnix-gui \
	mpv \
	pipewire-libs-extra \
	showtime \
	spotify-client \
	spotify-ffmpeg \
	vlc \
	vlc-plugin-ffmpeg \
	vlc-plugin-gnome \
	vlc-plugin-gstreamer \
	vlc-plugins-base \
	vlc-plugins-extra \
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
    rm -f /etc/yum.repos.d/fedora-multimedia.repo && \
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


