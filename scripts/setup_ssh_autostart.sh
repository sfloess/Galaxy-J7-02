#!/data/data/com.termux/files/usr/bin/bash
# Setup SSH auto-start on boot
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/FlossWare/Samsung-Galaxy-J7

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Setup SSH Auto-Start on Boot                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check if OpenSSH is installed
if ! command -v sshd &> /dev/null; then
    echo "[1/5] Installing OpenSSH..."
    pkg install -y openssh
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install OpenSSH"
        exit 1
    fi
else
    echo "[1/5] OpenSSH already installed ✓"
fi

# Create .ssh directory
echo ""
echo "[2/5] Setting up SSH directory..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "✅ SSH directory configured"

# Generate SSH keys if they don't exist
echo ""
echo "[3/5] Checking SSH keys..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating ED25519 key pair..."
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
    echo "✅ SSH keys generated"
else
    echo "✅ SSH keys already exist"
fi

# Create boot directory and script
echo ""
echo "[4/5] Creating boot script..."
mkdir -p ~/.termux/boot

cat > ~/.termux/boot/start-sshd.sh << 'EOFBOOT'
#!/data/data/com.termux/files/usr/bin/bash

# Wait for network to be available (adjust if needed)
sleep 10

# Start SSH server
sshd

# Log the start
{
    echo "$(date): SSH server started"
    echo "IP: $(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' || echo 'Not connected')"
    echo "---"
} >> ~/sshd-boot.log
EOFBOOT

chmod +x ~/.termux/boot/start-sshd.sh
echo "✅ Boot script created: ~/.termux/boot/start-sshd.sh"

# Test SSH server
echo ""
echo "[5/5] Testing SSH server..."
sshd 2>/dev/null
if ps aux | grep -q "[s]shd"; then
    echo "✅ SSH server is running"
else
    echo "⚠️  SSH server may not have started properly"
fi

# Display information
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   ✅ SSH Auto-Start Configured!                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Install Termux:Boot app:"
echo "   https://f-droid.org/packages/com.termux.boot/"
echo ""
echo "2. Open Termux:Boot app ONCE to grant permissions"
echo ""
echo "3. Find your IP address:"
echo "   ifconfig wlan0 | grep inet"
echo ""
echo "4. Add your computer's public key for password-free access:"
echo "   echo 'YOUR_PUBLIC_KEY' >> ~/.ssh/authorized_keys"
echo ""
echo "5. Connect from another device:"
echo "   ssh -p 8022 $(whoami)@YOUR_PHONE_IP"
echo ""
echo "📍 Current Status:"
echo "   Username: $(whoami)"
echo "   SSH Port: 8022"
echo "   IP Address: $(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' || echo 'Not connected')"
echo ""
echo "   Public Key: ~/.ssh/id_ed25519.pub"
echo "   Authorized Keys: ~/.ssh/authorized_keys"
echo "   Boot Script: ~/.termux/boot/start-sshd.sh"
echo "   Boot Log: ~/sshd-boot.log"
echo ""
echo "🔒 Security Tip:"
echo "   Copy ~/.ssh/id_ed25519.pub to your computer and use key-based auth"
echo ""
echo "📖 Full documentation: docs/AUTO_START_SSH.md"
echo ""
