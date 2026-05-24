#!/data/data/com.termux/files/usr/bin/bash
# Install Debian with OpenSSH on SD card
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/FlossWare/Samsung-Galaxy-J7

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Install Debian with OpenSSH on SD Card                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Prerequisite checks
echo "[0/5] Checking prerequisites..."

# Check if proot-distro is installed
if ! command -v proot-distro &> /dev/null; then
    echo "❌ proot-distro not installed"
    echo "   Installing proot-distro..."
    pkg install -y proot-distro
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install proot-distro"
        exit 1
    fi
fi

# Check SD card setup
if [ ! -d ~/projects-sd ]; then
    echo "❌ SD card not configured"
    echo "   Run: bash ~/setup_termux_sdcard.sh first"
    exit 1
fi

# Check available space
SDCARD_PATH=""
if [ -d ~/storage/external-1 ]; then
    SDCARD_PATH=~/storage/external-1
elif [ -d ~/storage/external-2 ]; then
    SDCARD_PATH=~/storage/external-2
fi

if [ -n "$SDCARD_PATH" ]; then
    AVAILABLE=$(df "$SDCARD_PATH" 2>/dev/null | tail -1 | awk '{print $4}')
    AVAILABLE_MB=$((AVAILABLE / 1024))
    if [ $AVAILABLE_MB -lt 1000 ]; then
        echo "⚠️  Warning: Only ${AVAILABLE_MB}MB free on SD card"
        echo "   Debian requires ~1GB. Continue? (y/n)"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo "✅ SD card has ${AVAILABLE_MB}MB available"
    fi
fi

export PATH=/data/data/com.termux/files/usr/bin:$PATH
export PROOT_DISTRO_DIR=/data/data/com.termux/files/home/projects-sd/linux-distros

# Check if Debian already installed
if [ -d "$PROOT_DISTRO_DIR/debian" ]; then
    echo "⚠️  Debian already installed at $PROOT_DISTRO_DIR/debian"
    echo "   Remove and reinstall? (y/n)"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        proot-distro remove debian
    else
        echo "Skipping installation..."
        exit 0
    fi
fi

echo ""
echo "[1/5] Installing Debian to SD card..."
echo "      This will download ~47MB and take 2-3 minutes"
echo ""
proot-distro install debian

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Debian"
    echo "   Check your internet connection and try again"
    exit 1
fi

echo ""
echo "[2/5] Verifying Debian installation..."
if proot-distro list | grep -q "debian.*installed"; then
    echo "✅ Debian installed successfully"
else
    echo "❌ Debian installation verification failed"
    exit 1
fi

echo ""
echo "[3/5] Updating Debian package list..."
proot-distro login debian -- bash -c "apt update"

if [ $? -ne 0 ]; then
    echo "⚠️  Package list update failed, but continuing..."
fi

echo ""
echo "[4/5] Installing OpenSSH server and client..."
proot-distro login debian -- bash -c "apt install -y openssh-server openssh-client"

if [ $? -ne 0 ]; then
    echo "❌ Failed to install OpenSSH"
    echo "   Debian is installed but SSH setup incomplete"
    exit 1
fi

echo ""
echo "[5/5] Checking installation size..."
DU_SIZE=$(du -sh "$PROOT_DISTRO_DIR/debian" 2>/dev/null | cut -f1)
if [ -n "$DU_SIZE" ]; then
    echo "✅ Debian installation size: $DU_SIZE"
fi

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
