# VNC Desktop Access Guide

Complete guide for setting up and using VNC remote desktop on your Samsung Galaxy J7.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Starting VNC](#starting-vnc)
- [Connecting to VNC](#connecting-to-vnc)
- [VNC Clients](#vnc-clients)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)

## Overview

VNC (Virtual Network Computing) allows you to access a graphical desktop environment on your phone from any device with a VNC client.

**What you get:**
- ✅ Full LXDE desktop environment
- ✅ Access from any device (laptop, tablet, another phone)
- ✅ File manager, text editor, terminal
- ✅ Run graphical Linux applications
- ✅ 1280x720 resolution (configurable)

**Requirements:**
- ✅ Debian installed in Termux (proot-distro)
- ✅ Desktop environment installed (LXDE, FVWM, or JWM)
- ✅ WiFi connection
- ✅ VNC client on your accessing device

## Installation

### Quick Install (Recommended)

Use the minimal desktop installation script:

```bash
# On your phone in Termux
cp /sdcard/Download/install_desktop_minimal.sh ~/
bash ~/install_desktop_minimal.sh
```

This installs:
- LXDE desktop environment
- TigerVNC server
- Auto-generated start/stop scripts
- htop system monitor

**Storage required:** ~400MB

### Manual Installation

If you prefer manual setup:

```bash
# Enter Debian
proot-distro login debian

# Update packages
apt update

# Install LXDE desktop
DEBIAN_FRONTEND=noninteractive apt install -y \
    lxde-core \
    lxde-common \
    lxterminal

# Install VNC server
DEBIAN_FRONTEND=noninteractive apt install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    dbus-x11

# Configure VNC
mkdir -p ~/.vnc

# Set VNC password (default: cobbler)
echo 'cobbler' | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Create VNC startup script
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP=LXDE
export XDG_SESSION_TYPE=x11

dbus-launch --exit-with-session startlxde &
EOF
chmod +x ~/.vnc/xstartup

exit
```

## Starting VNC

### Using the Start Script (Recommended)

After installing with `install_desktop_minimal.sh`:

```bash
# On your phone in Termux
bash ~/start_desktop.sh
```

**Expected output:**
```
Starting LXDE desktop with VNC...
✅ VNC server started!

Connect with a VNC client:
  Address: 192.168.1.248:5901
  Password: cobbler

To stop VNC:
  bash ~/stop_desktop.sh
```

### Manual Start

```bash
# Enter Debian
proot-distro login debian

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 24
```

**Display numbers:**
- `:1` → Port 5901
- `:2` → Port 5902
- `:3` → Port 5903

### Stopping VNC

```bash
# Using stop script
bash ~/stop_desktop.sh

# Or manually
proot-distro login debian -- vncserver -kill :1
```

## Connecting to VNC

### Find Your Phone's IP Address

**On your phone in Termux:**

```bash
# Get IP address
ifconfig wlan0 | grep inet

# Or simpler
ip -4 addr show wlan0 | grep inet
```

**Example output:**
```
inet 192.168.1.248/24
```

Your phone's IP is **192.168.1.248**

### Connection Details

- **Address:** `YOUR_PHONE_IP:5901` (e.g., `192.168.1.248:5901`)
- **Port:** `5901` (for display :1)
- **Password:** `cobbler` (default)
- **Display:** `:1`

### Connect from Different Devices

**From Windows:**
1. Open your VNC client (RealVNC, TightVNC, etc.)
2. Enter address: `192.168.1.248:5901`
3. Click "Connect"
4. Enter password: `cobbler`

**From Mac:**
1. Open "Screen Sharing" or VNC client
2. Enter address: `vnc://192.168.1.248:5901`
3. Click "Connect"
4. Enter password: `cobbler`

**From Linux:**
```bash
vncviewer 192.168.1.248:5901
# Enter password when prompted
```

**From Android/iOS:**
1. Install VNC Viewer app
2. Add new connection
3. Address: `192.168.1.248`
4. Port: `5901`
5. Connect and enter password

## VNC Clients

### Recommended VNC Clients

**Windows:**
- **RealVNC Viewer** - https://www.realvnc.com/download/viewer/
- **TightVNC Viewer** - https://www.tightvnc.com/download.php
- **TigerVNC Viewer** - https://tigervnc.org/

**Mac:**
- **Built-in Screen Sharing** (Finder → Go → Connect to Server)
- **RealVNC Viewer**
- **TigerVNC Viewer**

**Linux:**
```bash
# Install TigerVNC viewer
sudo apt install tigervnc-viewer

# Or RealVNC
sudo apt install realvnc-vnc-viewer

# Connect
vncviewer 192.168.1.248:5901
```

**Android:**
- **VNC Viewer** by RealVNC (Play Store / F-Droid)
- **bVNC** (open source, F-Droid)

**iOS:**
- **VNC Viewer** by RealVNC (App Store)

### Client Configuration Tips

**For best performance:**
- Use "Medium" or "Low" quality settings
- Disable "Show remote cursor"
- Enable "Adaptive compression"
- Set color depth to 16-bit or 24-bit

**For best quality:**
- Use "High" quality
- Set color depth to 24-bit
- Enable "Full colors"

## Using the Desktop

### What's Available

**File Manager:**
- Click the folder icon in the taskbar
- Navigate folders, copy/move files
- Access: `~/` (Debian home), `/` (Debian root)

**Terminal:**
- Click "LXTerminal" in menu or taskbar
- Full Debian terminal access
- Install packages: `apt install PACKAGE`

**Text Editor:**
- Applications → Accessories → Text Editor
- Or use `vim` or `nano` in terminal

**System Monitor:**
```bash
# In terminal
htop
```

### Common Tasks in Desktop

**Install Applications:**
```bash
# In LXTerminal
apt update
apt install firefox-esr  # Web browser
apt install geany         # Code editor
apt install thunar        # File manager
apt install gimp          # Image editor
```

**Browse Files:**
1. Click folder icon in taskbar
2. Navigate to locations:
   - `/root/` - Debian home directory
   - `/storage/` - Android storage (if configured)

**Run Commands:**
1. Open LXTerminal
2. Run any Linux command
3. Install tools with `apt install`

## Troubleshooting

### VNC Won't Start

**Error: "vncserver: command not found"**

```bash
# VNC not installed
proot-distro login debian
apt update
apt install tigervnc-standalone-server
```

**Error: "A VNC server is already running as :1"**

```bash
# Kill existing server
proot-distro login debian -- vncserver -kill :1

# Start fresh
bash ~/start_desktop.sh
```

**Error: "Could not start Xvnc"**

```bash
# Check logs
proot-distro login debian
cat ~/.vnc/*.log

# Usually missing dependencies
apt update
apt install -y xorg dbus-x11
```

### Can't Connect to VNC

**Problem:** "Connection refused" or "Unable to connect"

**Solutions:**

1. **Check if VNC is running:**
   ```bash
   proot-distro login debian
   vncserver -list
   # Should show :1 running
   ```

2. **Check phone's IP address:**
   ```bash
   ifconfig wlan0 | grep inet
   # Make sure this matches what you're connecting to
   ```

3. **Check firewall (if any):**
   ```bash
   # Android doesn't have firewall by default
   # But some custom ROMs do
   ```

4. **Restart VNC:**
   ```bash
   bash ~/stop_desktop.sh
   bash ~/start_desktop.sh
   ```

### Wrong Password

**Problem:** "Authentication failed" or "Password incorrect"

**Default password:** `cobbler`

**Change password:**
```bash
proot-distro login debian

# Set new password
vncpasswd
# Enter new password twice

# Restart VNC
vncserver -kill :1
vncserver :1 -geometry 1280x720 -depth 24
```

### Blank/Black Screen

**Problem:** Connected but see only black screen

**Solutions:**

1. **Restart VNC:**
   ```bash
   bash ~/stop_desktop.sh
   bash ~/start_desktop.sh
   ```

2. **Check xstartup script:**
   ```bash
   proot-distro login debian
   cat ~/.vnc/xstartup
   # Should end with: startlxde &
   ```

3. **Check desktop is installed:**
   ```bash
   proot-distro login debian
   which startlxde
   # If not found: apt install lxde-core
   ```

### Slow/Laggy Performance

**Solutions:**

1. **Lower resolution:**
   ```bash
   # Edit start_desktop.sh
   # Change: -geometry 1280x720
   # To: -geometry 1024x600
   ```

2. **Reduce color depth:**
   ```bash
   # Change: -depth 24
   # To: -depth 16
   ```

3. **In VNC client settings:**
   - Lower quality to "Medium" or "Low"
   - Disable fancy graphics
   - Enable compression

4. **Close unused applications** in the desktop

### Desktop Frozen

**Problem:** Desktop not responding

**Solutions:**

1. **Kill and restart VNC:**
   ```bash
   proot-distro login debian -- vncserver -kill :1
   bash ~/start_desktop.sh
   ```

2. **Check system resources:**
   ```bash
   # In Termux (not Debian)
   htop
   # See if system is overloaded
   ```

## Advanced Configuration

### Change Resolution

Edit the start script:

```bash
# Edit start_desktop.sh
nano ~/start_desktop.sh

# Find line:
vncserver :1 -geometry 1280x720 -depth 24

# Change to desired resolution:
# 1920x1080 (Full HD)
# 1600x900 (HD+)
# 1366x768 (HD)
# 1024x768 (XGA)
# 800x600 (SVGA)
```

### Change VNC Password

```bash
proot-distro login debian
vncpasswd
# Enter new password twice

# Restart VNC
vncserver -kill :1
exit
bash ~/start_desktop.sh
```

### Multiple VNC Servers

Run multiple desktops on different displays:

```bash
proot-distro login debian

# Start first desktop (port 5901)
vncserver :1 -geometry 1280x720

# Start second desktop (port 5902)
vncserver :2 -geometry 1024x600

# List running servers
vncserver -list
```

### Auto-Start VNC on Boot

Add to SSH auto-start script:

```bash
# Edit boot script
nano ~/.termux/boot/start-ssh-servers.sh

# Add at the end:
proot-distro login debian -- bash -c "
    vncserver :1 -geometry 1280x720 -depth 24
" &
```

**Note:** Only works if Termux:Boot is installed and phone is unlocked.

### Security Improvements

**1. Use SSH Tunnel (Most Secure):**

Instead of connecting directly to VNC, tunnel through SSH:

```bash
# On your computer
ssh -L 5901:localhost:5901 -p 8022 u0_a181@192.168.1.248

# Then connect VNC to: localhost:5901
```

Benefits:
- ✅ Encrypted connection
- ✅ No VNC password needed
- ✅ More secure than raw VNC

**2. Change from Default Password:**

```bash
proot-distro login debian
vncpasswd
# Use a STRONG password
```

**3. Limit to Local Network:**

VNC is only accessible on your local WiFi network by default. Don't port-forward VNC through your router (very insecure).

### Install Different Desktop Environments

**XFCE (lighter than LXDE):**
```bash
proot-distro login debian
apt install -y xfce4 xfce4-terminal

# Update xstartup
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
dbus-launch --exit-with-session startxfce4 &
EOF
chmod +x ~/.vnc/xstartup
```

**MATE (modern, feature-rich):**
```bash
apt install -y mate-desktop-environment-core
# Update xstartup to use: mate-session &
```

**Openbox (minimal window manager):**
```bash
apt install -y openbox
# Update xstartup to use: openbox-session &
```

## Performance Tips

1. **Lower resolution** for better performance
2. **Use 16-bit color depth** instead of 24-bit
3. **Close unused applications** in the desktop
4. **Use lightweight apps** (e.g., PCManFM instead of Thunar)
5. **Connect via 5GHz WiFi** if available (faster than 2.4GHz)
6. **Keep phone plugged in** - desktop uses more battery

## Use Cases

**Remote Administration:**
- Manage files graphically
- Install and configure software
- Monitor system with GUI tools

**Development:**
- Use IDE like Geany or Code-OSS
- Test GUI applications
- Debug visually

**Education:**
- Learn Linux desktop environment
- Practice system administration
- Run educational software

**Productivity:**
- Run office applications (LibreOffice)
- Image editing (GIMP)
- PDF viewing and editing

## Resources

- [TigerVNC Documentation](https://tigervnc.org/)
- [LXDE Desktop](https://www.lxde.org/)
- [Termux Wiki](https://wiki.termux.com/)
- [VNC Viewer Download](https://www.realvnc.com/download/viewer/)

---

## Quick Reference

```bash
# Start VNC
bash ~/start_desktop.sh

# Stop VNC
bash ~/stop_desktop.sh

# Check if VNC is running
proot-distro login debian -- vncserver -list

# Kill VNC manually
proot-distro login debian -- vncserver -kill :1

# Change VNC password
proot-distro login debian -- vncpasswd

# View VNC logs
proot-distro login debian -- cat ~/.vnc/*.log
```

**Connection:**
- Address: `YOUR_PHONE_IP:5901`
- Password: `cobbler` (default)
- Resolution: 1280x720

---

**Your phone now has a full graphical desktop accessible from anywhere!**
