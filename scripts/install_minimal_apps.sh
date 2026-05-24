#!/data/data/com.termux/files/usr/bin/bash
#
# Minimal App Installation Script for Termux
# Run this on your phone in Termux: bash ~/install_minimal_apps.sh
#
# This installs only essential tools for a working development environment

set -e

echo "========================================"
echo "  Minimal Termux Setup"
echo "========================================"
echo ""

# Update package lists
echo "📦 Updating package lists..."
pkg update -y

# Core system tools
echo ""
echo "🔧 Installing core system tools..."
pkg install -y \
    termux-tools \
    termux-auth \
    coreutils \
    findutils \
    grep \
    sed \
    gawk

# Essential development tools
echo ""
echo "💻 Installing essential development tools..."
pkg install -y \
    git \
    vim \
    curl \
    wget \
    openssh \
    htop

# proot for running Linux distributions
echo ""
echo "🐧 Installing proot-distro..."
pkg install -y proot proot-distro

# Storage access
echo ""
echo "💾 Setting up storage access..."
termux-setup-storage

echo ""
echo "========================================"
echo "  ✅ Minimal Setup Complete!"
echo "========================================"
echo ""
echo "Installed packages:"
echo "  ✅ Core utilities (grep, sed, awk, etc.)"
echo "  ✅ termux-auth (for passwd command)"
echo "  ✅ Git"
echo "  ✅ Vim"
echo "  ✅ curl & wget"
echo "  ✅ OpenSSH (client and server)"
echo "  ✅ htop (system monitor)"
echo "  ✅ proot-distro (for Debian)"
echo ""
echo "Next steps:"
echo "  1. Set password: passwd"
echo "  2. Start SSH: sshd"
echo "  3. Install Debian: bash ~/install_debian_with_ssh.sh"
echo ""
