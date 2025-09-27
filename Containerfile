FROM quay.io/fedora/fedora-silverblue:43

# Copy Files
COPY rootfs/ /
COPY cosign.pub /etc/pki/containers/

# Add RPM Fusion
RUN dnf install -y gcc make libxcrypt-compat && \
    dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Core System Tools
RUN dnf install -y \
    android-tools \
    baobab \
    distrobox \
    gnome-themes-extra \
    ifuse \
    papers \
    scrcpy \
    showtime \
    moby-engine \
    docker-compose \
    tailscale \
    unrar

# Multimedia
RUN dnf install -y --allowerasing \
    ffmpeg \
    ffmpegthumbnailer \
    gstreamer1-vaapi \
    libavcodec-freeworld

# Hardware Acceleration
RUN dnf install -y \
    gstreamer1-plugin-openh264 \
    libva-intel-driver \
    mozilla-openh264

# Virtualization
RUN dnf install -y \
    edk2-ovmf \
    qemu-device-display-virtio-vga \
    qemu-device-usb-redirect \
    qemu-img \
    qemu-kvm-core \
    qemu-system-x86

RUN dnf install -y \
    incus

# Cleanup & Finalize
RUN dnf remove -y \
    gcc \
    make

RUN rm -rf /tmp/* && \
    rm -rf /var/cache/dnf/* /var/log/* /var/tmp/* && \
    mkdir -p /var/cache /var/log /var/tmp && \
    chmod 1777 /var/tmp && \
    rm -f /etc/yum.repos.d/zeno-scrcpy.repo && \
    dnf clean all
