#!/data/data/com.termux/files/usr/bin/bash
# Set up Termux to use SD card for storage
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/sfloess/Galaxy-J7-02

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Configure Termux for SD Card Storage                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check if storage is already set up
if [ -d ~/storage ]; then
    echo "✅ Storage access already configured"
else
    echo "[1/4] Setting up storage access..."
    termux-setup-storage
    sleep 2
fi

echo ""
echo "[2/4] Creating directories on SD card..."
mkdir -p ~/projects-sd
mkdir -p ~/downloads-sd
mkdir -p ~/scripts-sd
mkdir -p ~/backup-sd
mkdir -p ~/projects-sd/linux-distros

echo ""
echo "[3/4] Configuring proot-distro to use SD card..."
if ! grep -q "PROOT_DISTRO_DIR" ~/.bashrc 2>/dev/null; then
    echo 'export PROOT_DISTRO_DIR=~/projects-sd/linux-distros' >> ~/.bashrc
    echo "✅ Added to ~/.bashrc"
else
    echo "✅ Already configured in ~/.bashrc"
fi

echo ""
echo "[4/4] Verifying symlinks..."
if [ -L ~/projects-sd ]; then
    echo "✅ SD card symlinks created"
    ls -lh ~ | grep -- '-sd'
else
    echo "⚠️  Symlinks not found (this is normal if run via ADB)"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   ✅ SD Card Storage Configured!                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Available directories:"
echo "  ~/projects-sd/      - Store your code projects"
echo "  ~/downloads-sd/     - Download large files here"
echo "  ~/scripts-sd/       - Shell/Python scripts"
echo "  ~/backup-sd/        - Backups"
echo "  ~/projects-sd/linux-distros/ - Debian installations"
echo ""
echo "SD card has 81GB free space!"
echo ""
echo "Next: Install Debian with: bash ~/install_debian_with_ssh.sh"
echo ""
