# Minimal Setup Guide

Quick guide to set up your Samsung Galaxy J7 as a mini Linux computer with only essential components.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Minimal Installation](#minimal-installation)
- [Desktop Environment (Optional)](#desktop-environment-optional)
- [Auto-Start SSH](#auto-start-ssh)
- [Installed Components](#installed-components)

## Overview

This guide covers the **minimal installation** needed for a functional Linux development environment:

- **Termux**: Linux terminal for Android
- **Essential tools**: SSH, Git, Vim, htop
- **Debian** (optional): Full Linux distribution
- **Desktop** (optional): LXDE with VNC access

**Total storage required:**
- Minimal (Termux only): ~100MB
- With Debian: ~250MB
- With Desktop: ~650MB

## Quick Start

### Prerequisites

1. Samsung Galaxy J7 with USB debugging enabled
2. Phone connected to computer via USB
3. ADB installed on computer

### 1. Debloat the Device

From your computer:

```bash
cd Samsung-Galaxy-J7
bash scripts/aggressive_debloat.sh
```

### 2. Install Termux

```bash
# Download F-Droid
wget https://f-droid.org/F-Droid.apk

# Install F-Droid
adb install F-Droid.apk

# Download Termux (from F-Droid or GitHub)
wget https://f-droid.org/repo/com.termux_118.apk

# Install Termux
adb install com.termux_118.apk
```

### 3. Push Setup Scripts

```bash
# Push minimal setup script
adb push scripts/install_minimal_apps.sh /sdcard/Download/

# Push Debian installer (optional)
adb push scripts/install_debian_with_ssh.sh /sdcard/Download/

# Push desktop installer (optional)
adb push scripts/install_desktop_minimal.sh /sdcard/Download/

# Push SD card setup
adb push scripts/setup_termux_sdcard.sh /sdcard/Download/
```

## Minimal Installation

> **🚀 Can install remotely via SSH!** See [SSH_REMOTE_INSTALL.md](SSH_REMOTE_INSTALL.md) for installing from your computer without touching the phone.

### Option 1: Install Remotely (Recommended)

From your computer via SSH:

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash all_in_one_setup.sh"
```

See [SSH_REMOTE_INSTALL.md](SSH_REMOTE_INSTALL.md) for complete SSH setup guide.

### Option 2: Install on Phone

On your phone, open Termux and run:

```bash
# Copy setup script
cp /sdcard/Download/install_minimal_apps.sh ~/
chmod +x ~/install_minimal_apps.sh

# Run minimal installation
bash ~/install_minimal_apps.sh
```

This installs:
- ✅ Core utilities (grep, sed, awk)
- ✅ termux-auth (passwd command)
- ✅ Git
- ✅ Vim
- ✅ curl & wget
- ✅ OpenSSH (client and server)
- ✅ htop (system monitor)
- ✅ proot-distro (for Linux)

**Storage used:** ~100MB

### Set Password and Start SSH

```bash
# Set password for SSH access
passwd
# Enter password (e.g., "cobbler")

# Start SSH server
sshd

# Find your phone's IP
ifconfig wlan0 | grep inet
```

From another device:

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP
# Enter your password
```

## Add Debian (Optional)

For a full Linux distribution:

```bash
# Copy and run Debian installer
cp /sdcard/Download/install_debian_with_ssh.sh ~/
bash ~/install_debian_with_ssh.sh
```

This adds:
- ✅ Debian Linux (Trixie)
- ✅ OpenSSH server
- ✅ htop
- ✅ 1000+ packages available via apt

**Additional storage:** ~150MB

### Access Debian

```bash
# Enter Debian
proot-distro login debian

# Set root password
passwd

# Start SSH server (inside Debian)
/etc/init.d/ssh start
```

## Desktop Environment (Optional)

For graphical desktop access via VNC.

> **📖 Complete VNC Guide:** See [VNC_DESKTOP_GUIDE.md](VNC_DESKTOP_GUIDE.md) for comprehensive VNC setup, troubleshooting, and configuration.

```bash
# Copy and run desktop installer
cp /sdcard/Download/install_desktop_minimal.sh ~/
bash ~/install_desktop_minimal.sh
```

This adds:
- ✅ LXDE desktop environment
- ✅ VNC server (TigerVNC)
- ✅ Desktop applications (file manager, terminal, text editor)

**Additional storage:** ~400MB

### Start Desktop

```bash
# Start VNC server with LXDE
bash ~/start_desktop.sh
```

Connect with VNC client:
- **Address:** `YOUR_PHONE_IP:5901`
- **Password:** `cobbler`

**Stop desktop:**

```bash
bash ~/stop_desktop.sh
```

## Auto-Start SSH

To automatically start SSH servers on boot:

### Option 1: Install Termux:Boot (Recommended)

From your computer:

```bash
# Download Termux:Boot
wget -O termux-boot.apk "https://github.com/termux/termux-boot/releases/download/v0.8.1/termux-boot-app_v0.8.1%2Bgithub.debug.apk"

# Install Termux:Boot
adb install termux-boot.apk

# Push auto-start script
adb push scripts/setup_ssh_autostart.sh /sdcard/Download/
```

On your phone in Termux:

```bash
# Run auto-start setup
cp /sdcard/Download/setup_ssh_autostart.sh ~/
bash ~/setup_ssh_autostart.sh
```

**Important:** Open the Termux:Boot app once after installation to activate it.

### Option 2: Remote Start Script

If you can't install Termux:Boot, use the remote start script from your computer:

```bash
# After phone boots, run from your computer:
adb shell "run-as com.termux /data/data/com.termux/files/usr/bin/sshd"
```

Or create an alias:

```bash
# Add to ~/.bashrc on your computer:
alias j7-ssh='adb shell "run-as com.termux /data/data/com.termux/files/usr/bin/sshd"'

# Then just run:
j7-ssh
```

## Installed Components

### Minimal Setup (Termux Only)

| Component | Purpose | Storage |
|-----------|---------|---------|
| Termux | Linux terminal | ~50MB |
| Core utils | grep, sed, awk, etc. | ~10MB |
| Git | Version control | ~15MB |
| OpenSSH | Remote access | ~5MB |
| Vim | Text editor | ~10MB |
| htop | System monitor | ~1MB |
| proot-distro | Linux container manager | ~10MB |

**Total:** ~100MB

### With Debian

| Component | Purpose | Storage |
|-----------|---------|---------|
| Debian base | Full Linux OS | ~150MB |
| OpenSSH server | Remote access | ~5MB |
| htop | System monitor | ~1MB |

**Total:** ~250MB (including Termux)

### With Desktop

| Component | Purpose | Storage |
|-----------|---------|---------|
| LXDE | Desktop environment | ~300MB |
| VNC server | Remote desktop | ~50MB |
| Desktop apps | File manager, terminal | ~50MB |

**Total:** ~650MB (including Termux + Debian)

## Common Commands

### Termux

```bash
# Update packages
pkg update && pkg upgrade

# Install package
pkg install PACKAGE_NAME

# List installed packages
pkg list-installed

# Search for packages
pkg search KEYWORD

# Start SSH server
sshd

# Check running processes
ps aux

# Monitor system
htop
```

### Debian

```bash
# Enter Debian
proot-distro login debian

# Update packages
apt update && apt upgrade

# Install package
apt install PACKAGE_NAME

# Start SSH server
/etc/init.d/ssh start

# Monitor system
htop

# Exit Debian
exit
```

### VNC Desktop

```bash
# Start desktop
bash ~/start_desktop.sh

# Stop desktop
bash ~/stop_desktop.sh

# Inside Debian, kill VNC manually
vncserver -kill :1
```

## Troubleshooting

### SSH Not Working

```bash
# Check if sshd is running
pgrep -f sshd

# Restart SSH server
pkill sshd
sshd
```

### Password Reset

```bash
# In Termux
passwd

# In Debian
proot-distro login debian
passwd
```

### VNC Won't Start

```bash
# Kill existing VNC servers
proot-distro login debian -- vncserver -kill :1

# Restart VNC
bash ~/start_desktop.sh
```

### Out of Storage

```bash
# Clean package cache (Termux)
pkg clean

# Clean package cache (Debian)
proot-distro login debian -- apt clean
proot-distro login debian -- apt autoremove
```

## Next Steps

After minimal setup:

1. **Configure Git**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

2. **Set up SSH keys**:
   ```bash
   ssh-keygen -t ed25519
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Install additional tools**:
   ```bash
   # Python
   pkg install python
   
   # Node.js
   pkg install nodejs
   
   # Build tools
   pkg install clang make
   ```

4. **Configure SD card storage**:
   ```bash
   cp /sdcard/Download/setup_termux_sdcard.sh ~/
   bash ~/setup_termux_sdcard.sh
   ```

## Resources

- [Termux Wiki](https://wiki.termux.com/)
- [Termux Packages](https://github.com/termux/termux-packages)
- [Debian Documentation](https://www.debian.org/doc/)
- [LXDE Desktop](https://www.lxde.org/)

---

**Storage Summary:**
- Minimal: ~100MB (Termux + essential tools)
- + Debian: ~250MB total
- + Desktop: ~650MB total

**Perfect for:** Development, learning Linux, remote access, automation
