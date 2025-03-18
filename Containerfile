ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

# Copy Files
COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

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
	fish \
	firewall-config \
	flatpak-builder \
	fuse-encfs \
	fzf \
	gcc \
	gh \
	git-credential-oauth \
	gnome-themes-extra \
	gnome-tweaks \
	gvfs-nfs \
	htop \
	httpie \
	iftop \
	ifuse \
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
	make \
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
	strace \
	sstp-client \
	NetworkManager-sstp \
	NetworkManager-sstp-gnome \
	subversion \
	tailscale \
	tldr \
	tmux \
	traceroute \
	tokei \
	rar \
	ungoogled-chromium \
	wl-clipboard \
	yt-dlp \
	libproxy-bin \
	zstd

# H/W Video Acceleration
RUN dnf install -y --setopt=install_weak_deps=False \
	intel-vaapi-driver \
	libva \
	libva-utils \
	libva-intel-media-driver \
	mesa-va-drivers \
	openh264 \
	gstreamer1-plugin-openh264 \
	mozilla-openh264

# Multimedia
RUN dnf install -y --allowerasing --setopt=install_weak_deps=False \
	ffmpeg \
	ffmpeg-libs \
	ffmpegthumbnailer \
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
	PlexHTPC \
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
	x265 \
	flexiblas-openblas-serial

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
    rm -f /etc/yum.repos.d/wojnilowicz-ungoogled-chromium.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


