#!/data/data/com.termux/files/usr/bin/bash
# Install Debian with OpenSSH on SD card
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/sfloess/Galaxy-J7-02

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Install Debian with OpenSSH on SD Card                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

export PATH=/data/data/com.termux/files/usr/bin:$PATH
export PROOT_DISTRO_DIR=/data/data/com.termux/files/home/projects-sd/linux-distros

echo "[1/3] Installing Debian to SD card..."
echo "      This will download ~47MB and take 2-3 minutes"
echo ""
proot-distro install debian

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Debian"
    exit 1
fi

echo ""
echo "[2/3] Updating Debian package list..."
proot-distro login debian -- bash -c "apt update"

echo ""
echo "[3/3] Installing OpenSSH server and client..."
proot-distro login debian -- bash -c "apt install -y openssh-server openssh-client"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   ✅ Installation Complete!                                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Debian with OpenSSH installed successfully!"
echo ""
echo "Storage: ~/projects-sd/linux-distros/debian (SD card)"
echo ""
echo "Next steps:"
echo "  1. Enter Debian:     proot-distro login debian"
echo "  2. Set root password: passwd"
echo "  3. Start SSH server: /etc/init.d/ssh start"
echo ""
echo "See /sdcard/Download/DEBIAN_SSH_GUIDE.txt for full documentation"
echo ""
