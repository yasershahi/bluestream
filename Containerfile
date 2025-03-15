ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

# Add RPM Fusion
RUN dnf install -y gcc make libxcrypt-compat
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Additional Packages
RUN dnf install -y \
	tailscale \
	gnome-themes-extra \
	gnome-tweaks \
	net-tools \
	nss-tools \
	android-tools \
	ifuse \
	liberation-fonts-all \
	fastfetch \
	libimobiledevice \
	libsss_autofs \
	libxcrypt-compat \
	scrcpy \
	gh \
	git-credential-oauth \
	code \
	aria2 \
	fish \
	unrar \
	p7zip \
	p7zip-plugins \
	ffmpegthumbnailer \
	gvfs-nfs \
	heif-pixbuf-loader \
	pipx \
	subversion \
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
        mesa-vdpau-drivers-freeworld

# Brave Browser
RUN mv /opt{,.bak} \
    && \
    mkdir /opt \
    && \
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
    && \
    dnf install -y brave-browser \
    && \
    mkdir -p usr/share/icons/hicolor/{16x16/apps,24x24/apps,32x32/apps,48x48/apps,64x64/apps,128x128/apps,256x256/apps} \
    && \
    for i in "16" "24" "32" "48" "64" "128" "256"; do \
        ln -sf /opt/brave.com/brave/product_logo_$i.png /usr/share/icons/hicolor/${i}x${i}/apps/brave-browser.png \
    ; done \
    && \
    rm -rf /etc/cron.daily \
    && \
    rmdir /opt/{brave.com,} \
    && \
    mv /opt{.bak,}

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
    rm -f /etc/yum.repos.d/brave-browser.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


