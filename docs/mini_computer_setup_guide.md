# Samsung J7 Mini Computer - Setup Guide

Your phone is now a lean Android mini computer! Here's how to set it up for maximum productivity.

> **📖 Setup Guides Available:**
> - **[MINIMAL_SETUP_GUIDE.md](MINIMAL_SETUP_GUIDE.md)** - Start with essentials, add as needed
> - **[TERMUX_DEBIAN_GUIDE.md](TERMUX_DEBIAN_GUIDE.md)** - Full Debian Linux setup
> - **[TERMUX_BOOT_SETUP.md](TERMUX_BOOT_SETUP.md)** - Auto-start SSH on boot
> - **[AUTO_START_SSH.md](AUTO_START_SSH.md)** - SSH auto-start configuration
>
> This guide covers **usage and applications**.

---

## 🚀 Essential Apps to Install

### 1. **Termux** (Linux Terminal Environment)
**Install from:** F-Droid or GitHub
**What it does:** Full Linux terminal with package manager (pkg)
**Use cases:**
```bash
# Install packages
pkg install python nodejs git vim openssh

# Run a web server
python -m http.server 8000

# SSH into other machines
ssh user@hostname

# Run scripts and programs
python script.py
```

### 2. **F-Droid** (Open Source App Store)
**Install from:** https://f-droid.org/
**Why:** All open-source apps, no tracking, perfect for mini computer use
**Recommended apps:**
- Termux (terminal)
- Simple File Manager (lightweight)
- Gadgetbridge (if you have smartwatch)
- NewPipe (YouTube without ads)
- OsmAnd~ (offline maps)

### 3. **Code Editor**
**Options:**
- **Acode** - Full-featured code editor (Play Store)
- **QuickEdit** - Fast text editor (Play Store)
- **Vim in Termux** - Classic terminal editor

### 4. **Remote Access**
**SSH Server (in Termux):**
```bash
pkg install openssh
passwd  # Set password
sshd    # Start SSH server
```

**VNC Server:** Install from Play Store for graphical remote access

### 5. **Development Tools**

**Python Development:**
```bash
# In Termux
pkg install python
pip install numpy pandas requests flask
```

**Node.js Development:**
```bash
pkg install nodejs
npm install -g http-server nodemon
```

**Git Version Control:**
```bash
pkg install git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## 💡 Mini Computer Use Cases

### 1. Portable Development Machine
- Write and test code on the go
- Run web servers for testing
- Git version control
- SSH into remote servers

### 2. Network Tools
```bash
# Port scanning
pkg install nmap
nmap 192.168.1.1

# Network monitoring
pkg install termux-api
termux-wifi-connectioninfo

# Speed testing (you have speedtest app already)
```

### 3. Automation & Scripting
```bash
# Create automation scripts
vim ~/scripts/backup.sh
chmod +x ~/scripts/backup.sh

# Schedule with cron
pkg install cronie
crontab -e
```

### 4. Media Server
```bash
# HTTP file server
python -m http.server 8080

# Access from other devices at:
# http://[phone-ip]:8080
```

### 5. Learning Platform
- Practice coding
- Learn Linux commands
- Test Android apps
- Cybersecurity practice (ethical hacking tools in Termux)

---

## 🔧 Termux Essential Commands

### Package Management
```bash
pkg update          # Update package lists
pkg upgrade         # Upgrade all packages
pkg install [name]  # Install a package
pkg search [name]   # Search for packages
pkg list-installed  # List installed packages
```

### Useful Packages
```bash
# System tools
pkg install vim git curl wget htop ncdu

# Programming languages
pkg install python nodejs ruby php

# Networking
pkg install nmap netcat-openbsd openssh

# Databases
pkg install sqlite postgresql mariadb

# Media
pkg install ffmpeg imagemagick

# Fun stuff
pkg install fortune cowsay sl
```

### File System Access
```bash
# Setup storage access
termux-setup-storage

# Now you can access:
~/storage/shared     # Internal storage
~/storage/external-1 # SD card
~/storage/dcim       # Camera photos
```

---

## 🌐 Network Configuration

### Get Phone IP Address
```bash
# In Termux
ip addr show wlan0 | grep inet

# Or use Android app: Network Info II
```

### Setup SSH Server
```bash
pkg install openssh
whoami  # Note your username
passwd  # Set a password
sshd    # Start SSH server (port 8022)

# From your computer:
ssh [username]@[phone-ip] -p 8022
```

### File Transfer
```bash
# Using SCP
scp -P 8022 file.txt [username]@[phone-ip]:~/

# Or use an app: Solid Explorer, FX File Explorer
```

---

## 📱 Optimize for Mini Computer Use

### 1. Keep Screen On During Development
**Settings → Developer Options → Stay Awake** (when charging)

### 2. Enable Developer Options
**Settings → About Phone → Tap Build Number 7 times**

### 3. Increase Font/Display Size
**Settings → Display → Font Size** (for easier reading)

### 4. Use External Keyboard/Mouse
- Bluetooth keyboard
- USB OTG adapter + wired keyboard/mouse
- Perfect for coding!

### 5. Battery Optimization
**Disable for:**
- Termux (if running servers)
- SSH clients
- Development apps

---

## 🎯 Project Ideas

### Beginner
1. Personal file server
2. Todo list app
3. Password manager
4. Note-taking system
5. Website tester

### Intermediate
1. Home automation controller
2. Network monitor
3. Git repository host
4. Local wiki/documentation server
5. Media streaming server

### Advanced
1. Docker container testing (via proot)
2. Penetration testing lab
3. Machine learning experiments
4. IoT device controller
5. Custom Android automation

---

## 🛡️ Security Tips

1. **Keep SSH Server Secure:**
```bash
# Use key-based auth instead of password
ssh-keygen -t rsa -b 4096
```

2. **Firewall (if rooted):**
```bash
# AFWall+ app from F-Droid
```

3. **Encrypted Storage:**
- Use Samsung Secure Folder (if still available)
- Or encrypted zip: `pkg install p7zip`

4. **Regular Updates:**
```bash
pkg update && pkg upgrade
```

---

## 📊 Performance Monitoring

### Check System Resources
```bash
# In Termux
pkg install htop
htop

# Check disk space
df -h

# Check memory
free -h

# Monitor processes
top
```

### Battery Stats
```bash
pkg install termux-api
termux-battery-status
```

---

## 🎓 Learning Resources

**Termux:**
- https://wiki.termux.com/
- https://github.com/termux/termux-app

**Android Development:**
- Termux + Python/Node.js tutorials
- Android Debug Bridge (ADB) - you're already using it!

**Linux Commands:**
- Practice in Termux
- Same commands as desktop Linux

---

## ✅ Daily Workflow Example

### Morning Routine
```bash
# Start Termux
pkg update              # Check for updates
cd ~/projects          # Go to projects
git pull               # Update code
vim script.py          # Edit code
python script.py       # Test
git commit -am "update" # Save changes
```

### Development Session
```bash
# Start web server
cd ~/website
python -m http.server 8000 &

# Start SSH server
sshd

# Open code editor
acode ~/projects/app.js

# Access from laptop at:
# http://[phone-ip]:8000
```

### Automation
```bash
# Auto-backup script (~/scripts/backup.sh)
#!/data/data/com.termux/files/usr/bin/bash
cd ~/projects
git add .
git commit -m "Auto backup $(date)"
git push
```

---

## 🎉 You're All Set!

Your Samsung J7 is now:
- ✅ 70% less bloated
- ✅ Camera working perfectly
- ✅ Ready for development
- ✅ Optimized for mini computer use
- ✅ Saving photos to SD card (SD card)

**Next:** Install Termux and start coding! 🚀
