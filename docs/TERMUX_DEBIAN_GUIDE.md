# Termux & Debian Setup Guide

Complete guide for setting up Termux with Debian Linux on your Samsung Galaxy J7.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Using Debian](#using-debian)
- [SSH Access](#ssh-access)
- [Troubleshooting](#troubleshooting)

## Overview

This setup transforms your Samsung J7 into a portable Linux development machine by:

1. **Installing Termux** - Linux terminal environment for Android
2. **Configuring SD Card Storage** - Use SD card instead of limited internal storage
3. **Installing Debian** - Full Linux distribution via proot
4. **Setting up OpenSSH** - Remote access capabilities

### What You Get

- ✅ Full Debian Linux environment
- ✅ Package manager (apt) with 1000s of packages
- ✅ SSH server for remote access
- ✅ Development tools (git, python3, nodejs, vim, etc.)
- ✅ All stored on SD card (SD card)
- ✅ No root required

## Prerequisites

- ✅ Samsung Galaxy J7 with USB debugging enabled
- ✅ SD card inserted (128GB recommended)
- ✅ Termux installed from F-Droid
- ✅ Hacker's Keyboard installed (optional but recommended)
- ✅ WiFi connection for package downloads

## Quick Start

### Option 1: Automated Setup (Recommended)

All scripts are in `/sdcard/Download/` on your phone:

```bash
# In Termux, run:
cd ~/
cp /sdcard/Download/termux_setup.sh ~/
bash ~/termux_setup.sh

# Then install Debian:
cp /sdcard/Download/install_debian_with_ssh.sh ~/
bash ~/install_debian_with_ssh.sh
```

### Option 2: Manual Setup

```bash
# 1. Set up storage
termux-setup-storage

# 2. Configure SD card
echo 'export PROOT_DISTRO_DIR=~/projects-sd/linux-distros' >> ~/.bashrc
source ~/.bashrc

# 3. Install proot-distro
pkg update
pkg install proot-distro

# 4. Install Debian
proot-distro install debian

# 5. Install OpenSSH in Debian
proot-distro login debian -- bash -c "apt update && apt install -y openssh-server"
```

## Detailed Setup

### Step 1: Termux Environment Setup

The `termux_setup.sh` script installs essential development tools:

- **Core Tools**: git, vim, curl, wget, openssh
- **Languages**: Python 3, Node.js, Ruby, PHP, Go
- **Build Tools**: make, clang, pkg-config
- **Utilities**: htop, ncdu, tree, zip/unzip

Storage usage: ~200MB on internal storage

### Step 2: SD Card Configuration

The `setup_termux_sdcard.sh` script creates:

```
~/projects-sd/          → /storage/<SD-CARD>/Android/data/com.termux/files/projects/
~/downloads-sd/         → /storage/<SD-CARD>/Android/data/com.termux/files/downloads/
~/scripts-sd/           → /storage/<SD-CARD>/Android/data/com.termux/files/scripts/
~/backup-sd/            → /storage/<SD-CARD>/Android/data/com.termux/files/backup/
~/projects-sd/linux-distros/ → Where Debian installs
```

Benefits:
- SD card space on SD card
- Internal storage saved for executables
- Projects and data on removable storage

### Step 3: Debian Installation

The `install_debian_with_ssh.sh` script:

1. Downloads Debian base (~47MB)
2. Installs to SD card (~150MB extracted)
3. Updates package lists
4. Installs OpenSSH server and client (~687MB total with dependencies)

Installation time: 5-10 minutes

### Step 4: OpenSSH Configuration

OpenSSH is pre-configured with:

- **Version**: OpenSSH 10.0p1
- **Port**: 22 (default)
- **Auth**: Password and key-based
- **Keys Generated**: RSA (3072-bit), ECDSA (256-bit), ED25519 (256-bit)

## Using Debian

### Enter Debian Environment

```bash
proot-distro login debian
```

You're now in a full Debian system!

### Install Packages

```bash
# Update package list
apt update

# Install development tools
apt install -y git python3 python3-pip nodejs npm vim nano

# Install servers
apt install -y nginx postgresql redis-server

# Install build tools
apt install -y build-essential cmake

# Install utilities
apt install -y htop tmux screen curl wget
```

### Exit Debian

```bash
exit
```

### Manage Debian

```bash
# List installed distributions
proot-distro list

# Remove Debian
proot-distro remove debian

# Reinstall Debian
proot-distro install debian

# Backup Debian
proot-distro backup debian
```

## SSH Access

### Start SSH Server

Inside Debian:

```bash
proot-distro login debian

# Start SSH server
/etc/init.d/ssh start

# Check status
/etc/init.d/ssh status
```

### Set Root Password

```bash
# Inside Debian
passwd
# Enter new password twice
```

### Configure SSH

Edit SSH config:

```bash
nano /etc/ssh/sshd_config
```

Important settings:

```bash
# Allow root login with password
PermitRootLogin yes

# Allow password authentication
PasswordAuthentication yes

# Change default port (optional, more secure)
Port 2222
```

Restart SSH after changes:

```bash
/etc/init.d/ssh restart
```

### Connect from Another Device

1. **Find phone's IP address** (in Termux):
   ```bash
   ifconfig wlan0 | grep inet
   # or
   ip addr show wlan0
   ```

2. **Connect via SSH**:
   ```bash
   ssh root@YOUR_PHONE_IP
   # or if you changed the port:
   ssh -p 2222 root@YOUR_PHONE_IP
   ```

### SSH Key Authentication (More Secure)

On your computer:

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519

# Copy key to phone
ssh-copy-id root@YOUR_PHONE_IP
```

Inside Debian, disable password authentication:

```bash
nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
/etc/init.d/ssh restart
```

## Storage Management

### Check Storage Usage

```bash
# SD card space
df -h ~/projects-sd

# Debian installation size
du -sh ~/projects-sd/linux-distros/debian

# Total Termux usage
du -sh ~
```

### Clean Up Old Packages

Inside Debian:

```bash
# Remove downloaded package files
apt clean

# Remove unnecessary packages
apt autoremove
```

## Common Tasks

### Run a Python Web Server

```bash
proot-distro login debian

# Install Flask
apt install -y python3-flask

# Create app
cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from Debian on Android!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Run server
python3 app.py
```

Access from browser: `http://YOUR_PHONE_IP:5000`

### Set Up Git

```bash
proot-distro login debian

git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Generate SSH key for GitHub
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub
# Copy this key to GitHub settings
```

### Run a Database

```bash
proot-distro login debian

# Install PostgreSQL
apt install -y postgresql postgresql-client

# Start PostgreSQL
/etc/init.d/postgresql start

# Create database
sudo -u postgres createdb mydb
```

## Troubleshooting

### Debian Won't Start

```bash
# Check if installed
proot-distro list

# Remove and reinstall
proot-distro remove debian
bash ~/install_debian_with_ssh.sh
```

### SSH Server Won't Start

```bash
# Inside Debian, check logs
cat /var/log/auth.log

# Manually start with debugging
/usr/sbin/sshd -d

# Check if port is already in use
netstat -tlnp | grep :22
```

### Out of Space

```bash
# Check what's using space
du -sh ~/projects-sd/linux-distros/* | sort -h

# Clean Debian cache
proot-distro login debian
apt clean
apt autoremove
```

### Can't Access SD Card

```bash
# Re-run storage setup
termux-setup-storage

# Check symlinks
ls -la ~ | grep storage
```

## Performance Tips

1. **Use SD card for large files** - Store projects, downloads, and databases on SD card
2. **Keep executables internal** - Termux binaries stay on internal storage (noexec on SD card)
3. **Regular cleanup** - Run `apt clean` and `apt autoremove` periodically
4. **Monitor storage** - Check `df -h` regularly

## Security Considerations

1. **Change default passwords** - Always set strong passwords
2. **Use SSH keys** - More secure than password authentication
3. **Change default SSH port** - Reduces automated attack attempts
4. **Firewall (optional)** - Install `ufw` in Debian for additional security
5. **Keep updated** - Regularly run `apt update && apt upgrade`

## Resources

- [Termux Wiki](https://wiki.termux.com/)
- [Proot-Distro Documentation](https://github.com/termux/proot-distro)
- [Debian Documentation](https://www.debian.org/doc/)
- [OpenSSH Manual](https://www.openssh.com/manual.html)

## File Locations

| File/Directory | Location | Purpose |
|---------------|----------|---------|
| Termux home | `/data/data/com.termux/files/home/` | Termux files |
| SD card projects | `~/projects-sd/` | Code projects |
| Debian installation | `~/projects-sd/linux-distros/debian/` | Debian rootfs |
| SSH config | `~/projects-sd/linux-distros/debian/etc/ssh/` | SSH settings |
| Setup scripts | `/sdcard/Download/` | Installation scripts |

## Summary

You now have:
- ✅ Termux with development tools (~200MB internal)
- ✅ Debian Linux on SD card (~687MB)
- ✅ OpenSSH server for remote access
- ✅ Full Linux environment with 80GB free space
- ✅ Portable development platform

Your Samsung J7 is now a mini Linux server! 🚀
