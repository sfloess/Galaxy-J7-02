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

# Configure SSH to allow password authentication
echo ""
echo "[2.5/5] Configuring SSH server..."
mkdir -p $PREFIX/etc/ssh
if [ ! -f $PREFIX/etc/ssh/sshd_config ]; then
    # Generate default config first
    sshd 2>/dev/null
    sleep 1  # Wait for sshd to generate config files
    pkill sshd
fi

# Ensure password authentication is enabled
if [ -f $PREFIX/etc/ssh/sshd_config ]; then
    # Backup original config
    cp $PREFIX/etc/ssh/sshd_config $PREFIX/etc/ssh/sshd_config.bak

    # Enable password authentication (explicitly)
    if grep -q "^PasswordAuthentication" $PREFIX/etc/ssh/sshd_config; then
        sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' $PREFIX/etc/ssh/sshd_config
    else
        echo "PasswordAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
    fi

    # Allow public key authentication too
    if grep -q "^PubkeyAuthentication" $PREFIX/etc/ssh/sshd_config; then
        sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' $PREFIX/etc/ssh/sshd_config
    else
        echo "PubkeyAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
    fi

    echo "✅ SSH server configured for password and key authentication"
else
    echo "⚠️  sshd_config not found, using defaults"
fi

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
echo "1. Set a password for SSH access:"
echo "   passwd"
echo "   (Choose a strong password!)"
echo ""
echo "2. Install Termux:Boot app:"
echo "   https://f-droid.org/packages/com.termux.boot/"
echo ""
echo "3. Open Termux:Boot app ONCE to grant permissions"
echo ""
echo "4. Find your IP address:"
echo "   ifconfig wlan0 | grep inet"
echo ""
echo "5. Connect from another device with PASSWORD:"
echo "   ssh -p 8022 $(whoami)@YOUR_PHONE_IP"
echo "   (Enter the password you set in step 1)"
echo ""
echo "6. Optional - Add your computer's public key for password-free access:"
echo "   echo 'YOUR_PUBLIC_KEY' >> ~/.ssh/authorized_keys"
echo ""
echo "📍 Current Status:"
echo "   Username: $(whoami)"
echo "   SSH Port: 8022"
echo "   IP Address: $(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' || echo 'Not connected')"
echo "   Authentication: Password + Key (both enabled)"
echo ""
echo "   Config File: $PREFIX/etc/ssh/sshd_config"
echo "   Public Key: ~/.ssh/id_ed25519.pub"
echo "   Authorized Keys: ~/.ssh/authorized_keys"
echo "   Boot Script: ~/.termux/boot/start-sshd.sh"
echo "   Boot Log: ~/sshd-boot.log"
echo ""
echo "🔒 Security Notes:"
echo "   ✅ Password authentication: ENABLED (set password with 'passwd')"
echo "   ✅ Public key authentication: ENABLED"
echo "   ⚠️  Set a STRONG password - your phone will be accessible over network!"
echo ""
echo "   To disable password auth later (more secure):"
echo "   Edit $PREFIX/etc/ssh/sshd_config and set: PasswordAuthentication no"
echo ""
echo "📖 Full documentation: docs/AUTO_START_SSH.md"
echo ""
