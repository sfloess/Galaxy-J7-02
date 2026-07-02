#!/bin/bash
# Setup Samsung J7 as Fleet Worker Node (like pi-01)
# Integrates with existing 6-node distributed orchestration framework

set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   SETUP J7 AS FLEET WORKER NODE                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

echo "This will configure your Samsung J7 to work as a compute node"
echo "in your distributed fleet (like pi-01, pi-02, etc.)"
echo ""
echo "📋 Installation Steps:"
echo "  1. Install core packages in Termux"
echo "  2. Setup SSH server"
echo "  3. Configure auto-start (Termux:Boot)"
echo "  4. Setup Python environment"
echo "  5. Setup Node.js environment"
echo "  6. Configure network access"
echo ""

read -p "Continue? (y/n) " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo ""
echo "📱 STEP 1: Configure Termux"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "On your phone, open Termux and run these commands:"
echo ""
cat << 'EOF'
# Update package list
pkg update -y

# Install core tools
pkg install -y openssh python nodejs git wget curl

# Generate SSH key (if not exists)
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

# Setup SSH server
# Set password for SSH access
passwd

# Start SSH server
sshd

# Check SSH is running
pgrep sshd && echo "✓ SSH server running on port 8022"

# Get IP address
ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d/ -f1

# Print connection info
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "SSH Connection Info:"
echo "  ssh -p 8022 $(whoami)@YOUR_IP_FROM_ABOVE"
echo "════════════════════════════════════════════════════════════════"
EOF

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "⚠️  STOP: Run the above commands in Termux on your phone"
echo ""

read -p "Press ENTER when SSH server is running in Termux..."

echo ""
echo "📱 STEP 2: Get Device IP Address"
echo "════════════════════════════════════════════════════════════════"

# Get device IP
DEVICE_IP=$(adb shell ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d/ -f1 | tr -d '\r\n')

if [ -z "$DEVICE_IP" ]; then
    echo "❌ Could not detect IP address"
    echo "   Manually check with: ip addr show wlan0 in Termux"
    exit 1
fi

echo "✓ Device IP: $DEVICE_IP"
echo ""

echo "📱 STEP 3: Test SSH Connection"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "From your laptop, try connecting:"
echo "  ssh -p 8022 u0_a<USER_ID>@$DEVICE_IP"
echo ""
echo "Username format: u0_a178 (check 'whoami' in Termux)"
echo "Password: The one you set with 'passwd' command"
echo ""

read -p "Press ENTER after successful SSH connection test..."

echo ""
echo "📱 STEP 4: Configure Auto-Start (Termux:Boot)"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "On your phone, in Termux, run:"
echo ""
cat << 'EOF'
# Create boot script directory
mkdir -p ~/.termux/boot

# Create SSH auto-start script
cat > ~/.termux/boot/start-sshd << 'SCRIPT'
#!/data/data/com.termux/files/usr/bin/bash
# Start SSH server on boot

# Wait for network
sleep 10

# Start SSH
sshd

# Log startup
echo "$(date): SSH server started" >> ~/boot.log
SCRIPT

# Make executable
chmod +x ~/.termux/boot/start-sshd

# Test it
~/.termux/boot/start-sshd
pgrep sshd && echo "✓ SSH auto-start configured"
EOF

echo ""
read -p "Press ENTER when auto-start is configured..."

echo ""
echo "📱 STEP 5: Fleet Integration"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Node Information:"
echo "  Hostname: android-j7"
echo "  IP: $DEVICE_IP"
echo "  SSH Port: 8022"
echo "  Cores: 8 (octa-core)"
echo "  RAM: ~2GB available"
echo "  Storage: 81GB (SD card)"
echo ""
echo "Add to your fleet configuration:"
echo ""
cat << FLEET_CONFIG
# In your fleet management config:
{
  "node": "android-j7",
  "host": "$DEVICE_IP",
  "port": 8022,
  "arch": "aarch64",
  "cores": 8,
  "ram_gb": 2,
  "storage_gb": 81,
  "role": "worker",
  "capabilities": ["python", "nodejs", "lightweight-tasks"]
}
FLEET_CONFIG

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ SETUP COMPLETE!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Your Samsung J7 is now configured as a fleet worker node!"
echo ""
echo "📊 Next Steps:"
echo "  1. Add SSH key to laptop for passwordless access:"
echo "     ssh-copy-id -p 8022 u0_a<ID>@$DEVICE_IP"
echo ""
echo "  2. Test remote execution:"
echo "     ssh -p 8022 u0_a<ID>@$DEVICE_IP 'python3 --version'"
echo ""
echo "  3. Add to your workflow orchestration scripts"
echo ""
echo "  4. Monitor with Grafana (connect to pi-02:3000)"
echo ""
echo "⚠️  IMPORTANT:"
echo "  - Keep phone charged or plugged in"
echo "  - Keep WiFi connected"
echo "  - Termux:Boot will auto-start SSH on reboot"
echo ""
