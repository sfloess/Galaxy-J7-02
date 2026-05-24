#!/data/data/com.termux/files/usr/bin/bash
#
# Minimal Desktop Environment Installation Script
# Run this on your phone in Termux: bash ~/install_desktop_minimal.sh
#
# Installs LXDE desktop environment and VNC server in Debian

set -e

echo "========================================"
echo "  Minimal Desktop Setup"
echo "========================================"
echo ""

# Check if Debian is installed
if ! proot-distro list 2>/dev/null | grep -q "debian"; then
    echo "❌ Error: Debian is not installed."
    echo "   Please run: bash ~/install_debian_with_ssh.sh"
    exit 1
fi

echo "Installing desktop environment in Debian..."
echo "This will take 10-15 minutes and use ~400MB of space."
echo ""

# Install LXDE and VNC in Debian
proot-distro login debian -- bash -c "
set -e

echo '📦 Updating package lists...'
apt update

echo ''
echo '🖥️  Installing LXDE desktop environment...'
DEBIAN_FRONTEND=noninteractive apt install -y \
    lxde-core \
    lxde-common \
    lxterminal

echo ''
echo '📺 Installing VNC server...'
DEBIAN_FRONTEND=noninteractive apt install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    dbus-x11

echo ''
echo '⚙️  Configuring VNC server...'
mkdir -p ~/.vnc

# Set VNC password
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

echo ''
echo '📊 Installing system monitor...'
DEBIAN_FRONTEND=noninteractive apt install -y htop

echo ''
echo '✅ Desktop installation complete!'
"

# Create desktop launcher script
cat > ~/start_desktop.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
#
# Desktop launcher script
# Usage: bash ~/start_desktop.sh

echo "Starting LXDE desktop with VNC..."

proot-distro login debian -- bash -c "
    # Kill any existing VNC servers
    vncserver -kill :1 2>/dev/null || true

    # Start VNC server
    vncserver :1 -geometry 1280x720 -depth 24

    echo ''
    echo '✅ VNC server started!'
    echo ''
    echo 'Connect with a VNC client:'
    echo '  Address: 192.168.1.248:5901'
    echo '  Password: cobbler'
    echo ''
    echo 'To stop VNC:'
    echo '  bash ~/stop_desktop.sh'
"
EOF
chmod +x ~/start_desktop.sh

# Create desktop stop script
cat > ~/stop_desktop.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
#
# Desktop stop script
# Usage: bash ~/stop_desktop.sh

echo "Stopping VNC server..."

proot-distro login debian -- bash -c "
    vncserver -kill :1
    echo '✅ VNC server stopped.'
"
EOF
chmod +x ~/stop_desktop.sh

echo ""
echo "========================================"
echo "  ✅ Desktop Setup Complete!"
echo "========================================"
echo ""
echo "Installed components:"
echo "  ✅ LXDE desktop environment"
echo "  ✅ VNC server (TigerVNC)"
echo "  ✅ htop (system monitor)"
echo ""
echo "To start desktop:"
echo "  bash ~/start_desktop.sh"
echo ""
echo "Then connect with VNC client to:"
echo "  Address: YOUR_PHONE_IP:5901"
echo "  Password: cobbler"
echo ""
