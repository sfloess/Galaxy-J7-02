#!/data/data/com.termux/files/usr/bin/bash
# Set up Termux to use SD card for storage
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/FlossWare/Samsung-Galaxy-J7

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

# Detect SD card path
SDCARD_PATH=""
if [ -d ~/storage/external-1 ]; then
    SDCARD_PATH=~/storage/external-1
elif [ -d ~/storage/external-2 ]; then
    SDCARD_PATH=~/storage/external-2
else
    echo "❌ No SD card found!"
    echo "   Make sure SD card is inserted and termux-setup-storage was run"
    exit 1
fi

echo "✅ SD card detected: $SDCARD_PATH"

# Create actual directories on SD card
mkdir -p "$SDCARD_PATH/Android/data/com.termux/files/projects"
mkdir -p "$SDCARD_PATH/Android/data/com.termux/files/downloads"
mkdir -p "$SDCARD_PATH/Android/data/com.termux/files/scripts"
mkdir -p "$SDCARD_PATH/Android/data/com.termux/files/backup"
mkdir -p "$SDCARD_PATH/Android/data/com.termux/files/projects/linux-distros"

# Remove old symlinks if they exist
rm -f ~/projects-sd ~/downloads-sd ~/scripts-sd ~/backup-sd

# Create symlinks from home to SD card
ln -s "$SDCARD_PATH/Android/data/com.termux/files/projects" ~/projects-sd
ln -s "$SDCARD_PATH/Android/data/com.termux/files/downloads" ~/downloads-sd
ln -s "$SDCARD_PATH/Android/data/com.termux/files/scripts" ~/scripts-sd
ln -s "$SDCARD_PATH/Android/data/com.termux/files/backup" ~/backup-sd

echo ""
echo "[3/4] Configuring proot-distro to use SD card..."
if ! grep -q "PROOT_DISTRO_DIR" ~/.bashrc 2>/dev/null; then
    echo 'export PROOT_DISTRO_DIR=~/projects-sd/linux-distros' >> ~/.bashrc
    echo "✅ Added to ~/.bashrc"
else
    echo "✅ Already configured in ~/.bashrc"
fi

echo ""
echo "[4/4] Verifying setup..."
if [ -L ~/projects-sd ] && [ -d ~/projects-sd ]; then
    echo "✅ SD card symlinks created successfully"
    echo ""
    ls -lh ~ | grep -- '-sd'
    echo ""
    echo "Available space on SD card:"
    df -h "$SDCARD_PATH" | tail -1 | awk '{print "  " $4 " free of " $2}'
else
    echo "❌ Symlink creation failed"
    exit 1
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
