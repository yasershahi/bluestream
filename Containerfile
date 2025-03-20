FROM quay.io/fedora/fedora-silverblue:rawhide

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
	fedora-workstation-backgrounds

# Stable Kernel
RUN dnf remove -y \
    kernel* \
    kernel-core* \
    kernel-modules* \
    kernel-modules-core* \
    kernel-modules-extra* \
    kernel-tools* \
    kernel-tools-libs* \
    kernel-headers*

RUN set -euo pipefail && \
    # Create a directory for the kernel RPMs
    mkdir -p /tmp/kernel && \
    # Download the kernel packages using the correct URLs
    curl -L -o /tmp/kernel/kernel-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-core-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-core-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-modules-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-modules-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-modules-core-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-modules-core-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-modules-extra-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-modules-extra-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-tools-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-tools-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-tools-libs-6.12.13-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/6.12.13/200.fc41/x86_64/kernel-tools-libs-6.12.13-200.fc41.x86_64.rpm && \
    curl -L -o /tmp/kernel/kernel-headers-6.12.4-200.fc41.x86_64.rpm https://kojipkgs.fedoraproject.org//packages/kernel-headers/6.12.4/200.fc41/x86_64/kernel-headers-6.12.4-200.fc41.x86_64.rpm && \
    # Install the downloaded RPMs
    dnf install -y /tmp/kernel/*.rpm && \
    # Clean up
    rm -rf /tmp/kernel


# Additional System Packages
RUN dnf install -y \
	aria2 \
	adcli \
	bat \
	dnf-utils \
	duf \
	fastfetch \
	fish \
	fzf \
	gnome-themes-extra \
	gnome-tweaks \
	htop \
	ifuse \
	iotop \
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
	code \
	devpod \
	distrobox \
	gh \
	git \
	git-credential-oauth \
	neovim \
	pipx \
	scrcpy \
	subversion

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

# H/W Video Acceleration
RUN dnf install -y \
	gstreamer1-plugin-openh264 \
	libva \
        libva-intel-driver \
        libva-intel-hybrid-driver \
        libva-intel-media-driver \
	libva-utils \
	mesa-va-drivers-freeworld \
	mesa-vdpau-drivers-freeworld \
	mozilla-openh264 \
	openh264

RUN dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Cleanup & Finalize
RUN rm -rf /tmp/* /var/*
RUN rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo && \
    rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm -f /etc/yum.repos.d/execat-mutter-performance.repo && \
    rm -f /etc/yum.repos.d/github.repo && \
    rm -f /etc/yum.repos.d/vscode.repo && \
    rm -f /etc/yum.repos.d/chronoscrat-devpod.repo && \
    rm -f /etc/yum.repos.d/cloudflare-warp.repo && \
    rm -f /etc/xdg/autostart/org.gnome.Software.desktop && \
    systemctl enable flatpak-add-flathub-repo.service && \
    systemctl enable flatpak-replace-fedora-apps.service && \
    systemctl enable flatpak-cleanup.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    dnf clean all


