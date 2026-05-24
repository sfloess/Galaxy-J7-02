# Auto-Start SSH Server on Boot

This guide shows how to automatically start an SSH server in Termux when your Galaxy J7 boots, turning it into an always-accessible remote Linux box.

## Overview

With Termux:Boot, your phone will:
- ✅ Start SSH server on boot (no manual intervention)
- ✅ Be accessible via SSH over WiFi
- ✅ Run in background (minimal battery impact)
- ✅ Survive reboots

## Prerequisites

- ✅ Termux installed and configured
- ✅ WiFi connected (static IP recommended)
- ⚠️ Phone must be unlocked for boot script to run

## Installation

### 1. Install Termux:Boot

From F-Droid or download:

```bash
# Download Termux:Boot APK
adb push apps/termux-boot.apk /sdcard/Download/

# Install on phone
adb install apps/termux-boot.apk
```

Or install from F-Droid: https://f-droid.org/packages/com.termux.boot/

### 2. Run Automated Setup Script

**RECOMMENDED:** Use the automated setup script:

```bash
# Push script to phone
adb push scripts/setup_ssh_autostart.sh /sdcard/Download/

# In Termux
cp /sdcard/Download/setup_ssh_autostart.sh ~
bash ~/setup_ssh_autostart.sh
```

The script will:
1. Install OpenSSH
2. **Ask you to choose authentication method** (see below)
3. Generate SSH keys
4. Create boot script
5. Test SSH server

Skip to step 6 if using the automated script.

### 3. Choose Authentication Method (IMPORTANT!)

The setup script will prompt you with 3 options:

```
🔒 SSH Authentication Method:
   1) SSH keys only (RECOMMENDED - most secure)
   2) Password only (less secure, but simpler)
   3) Both password and keys (convenient)

Choose option (1-3) [default: 1]:
```

**Option 1: SSH Keys Only (RECOMMENDED)**
- ✅ Most secure
- ✅ No password needed once keys are set up
- ✅ Immune to brute-force attacks
- ⚠️  Requires copying your public key to phone

**Option 2: Password Only**
- ⚠️  Less secure than keys
- ✅ Simpler to set up
- ⚠️  Vulnerable to brute-force if weak password
- ⚠️  Must use STRONG password

**Option 3: Both Methods**
- ✅ Convenient (use keys or password)
- ⚠️  Less secure than keys-only
- ⚠️  Must use STRONG password

### 4. Manual Setup (Alternative to Script)

If you prefer manual setup instead of the automated script:

#### Install OpenSSH

```bash
# In Termux
pkg install openssh
```

#### Configure Authentication

For **Option 1 (Keys Only)**:
```bash
# Generate SSH keys
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Set up authorized_keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your computer's public key
# From your computer: cat ~/.ssh/id_rsa.pub
# Paste the output into ~/.ssh/authorized_keys on phone

# Configure sshd for keys only
echo "PubkeyAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
echo "PasswordAuthentication no" >> $PREFIX/etc/ssh/sshd_config
```

For **Option 2 (Password Only)**:
```bash
# Set a STRONG password
passwd

# Configure sshd for password only
echo "PasswordAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
echo "PubkeyAuthentication no" >> $PREFIX/etc/ssh/sshd_config
```

For **Option 3 (Both)**:
```bash
# Set password
passwd

# Set up keys (see Option 1 above)
# ... 

# Configure sshd for both
echo "PubkeyAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> $PREFIX/etc/ssh/sshd_config
```

### 5. Create Boot Script (Manual Setup)

```bash
# Create boot scripts directory
mkdir -p ~/.termux/boot

# Create the SSH auto-start script
cat > ~/.termux/boot/start-sshd.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Wait for network to be available
sleep 10

# Start SSH server
sshd

# Log the start
echo "$(date): SSH server started" >> ~/sshd-boot.log
echo "IP: $(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')" >> ~/sshd-boot.log
EOF

# Make it executable
chmod +x ~/.termux/boot/start-sshd.sh
```

### 6. Grant Boot Permission

On your phone:
1. Open **Termux:Boot** app once (this is required!)
2. Android will ask for permission to run on boot - **Allow**
3. Close Termux:Boot

### 7. Test It

```bash
# Reboot your phone
adb reboot

# Wait ~30 seconds after boot

# Check if SSH server is running
ps aux | grep sshd

# Check the log
cat ~/sshd-boot.log

# Try to connect from another device
ssh -p 8022 <YOUR_PHONE_IP>
```

## SSH Server Configuration

### Default Settings

Termux SSH runs on **port 8022** (not 22) because Android doesn't allow port 22 without root.

**Authentication methods enabled:**
- ✅ **Password authentication** - Login with the password you set via `passwd`
- ✅ **Public key authentication** - Login with SSH keys (more secure)

```bash
# Connect from another device WITH PASSWORD
ssh -p 8022 192.168.1.XXX
# Enter your password when prompted

# Or use username explicitly
ssh -p 8022 u0_a123@192.168.1.XXX
```

**IMPORTANT:** Set a strong password in Termux:
```bash
# In Termux
passwd
# Enter and confirm a strong password
```

### Find Your Username

```bash
# In Termux
whoami
# Example output: u0_a123
```

### Find Your IP Address

```bash
# In Termux
ifconfig wlan0 | grep inet
# Or simpler:
ip -4 addr show wlan0 | grep inet | awk '{print $2}'
```

## Advanced Configuration

### Set Static IP (Recommended)

On your phone:
1. Go to **Settings** → **WiFi**
2. Long press your WiFi network → **Modify network**
3. **Advanced options** → **IP settings** → **Static**
4. Set a static IP (e.g., 192.168.1.100)
5. Save

This ensures your phone always has the same IP address.

### Password vs Key Authentication

**Password Authentication (Default):**
- ✅ Easy to set up: just run `passwd` in Termux
- ✅ Works from any computer without setup
- ⚠️ Less secure: vulnerable to brute force attacks
- ⚠️ Must type password every time

**Key Authentication (Recommended for regular use):**
- ✅ More secure: can't be brute-forced
- ✅ No password needed after setup
- ⚠️ Requires initial setup

**Set up Key Authentication:**

On your **computer** (not phone):

```bash
# Copy your public key to phone
ssh-copy-id -p 8022 192.168.1.100
# Enter your Termux password when prompted

# Now you can connect without password
ssh -p 8022 192.168.1.100
```

**Optional: Disable Password Auth (Most Secure):**

After setting up keys, you can disable password authentication:

```bash
# In Termux, edit sshd_config
nano $PREFIX/etc/ssh/sshd_config

# Change this line:
PasswordAuthentication no

# Save and restart SSH
pkill sshd
sshd
```

### Create SSH Config Shortcut

On your **computer**, add to `~/.ssh/config`:

```
Host galaxyj7
    HostName 192.168.1.100
    Port 8022
    User u0_a123
    IdentityFile ~/.ssh/id_ed25519
```

Now you can connect with just:
```bash
ssh galaxyj7
```

## Auto-Start Debian with SSH

If you want to auto-start the Debian environment with SSH:

### Configure Debian for Root Password Login

First, ensure Debian allows root login (this is done automatically by `install_debian_with_ssh.sh`):

```bash
# In Debian (proot-distro login debian)
nano /etc/ssh/sshd_config

# Ensure these settings:
PermitRootLogin yes
PasswordAuthentication yes

# Set root password if not already set
passwd
# Enter a STRONG password for Debian root
```

### Auto-Start Debian SSH on Boot

```bash
# Edit the boot script
nano ~/.termux/boot/start-sshd.sh
```

Replace with this:

```bash
#!/data/data/com.termux/files/usr/bin/bash

# Wait for network
sleep 10

# Start Termux SSH server (port 8022)
sshd

# Start Debian and its SSH server
proot-distro login debian -- bash -c "
    /etc/init.d/ssh start
    echo 'Debian SSH started on port 22 (inside proot)'
" &

# Log
{
    echo "$(date): Termux SSH (port 8022) and Debian SSH (port 22) started"
    echo "IP: $(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' || echo 'Not connected')"
    echo "Termux user: $(whoami)"
    echo "Debian root login: ENABLED with password"
    echo "---"
} >> ~/sshd-boot.log
```

### Accessing Debian SSH

**Important:** Debian SSH runs on port 22 but **only inside the proot environment**.

**To access Debian:**

```bash
# Method 1: SSH to Termux, then enter Debian
ssh -p 8022 192.168.1.100      # SSH to Termux
proot-distro login debian       # Enter Debian
# Now you're in Debian as root

# Method 2: One-liner from remote computer
ssh -p 8022 192.168.1.100 -t 'proot-distro login debian'
```

**Note:** You cannot SSH directly to port 22 on the phone. Debian's SSH server is isolated inside proot and not exposed to the network. You must always go through Termux first.

### Debian Root Password

Set a strong root password in Debian:

```bash
# Enter Debian
proot-distro login debian

# Set root password
passwd
# Enter a STRONG password (different from Termux password recommended)
```

This password is used:
- When entering Debian from Termux
- For sudo operations in Debian
- For any Debian services requiring authentication

## Security Considerations

### ⚠️ Important Security Notes

1. **Set STRONG passwords** - Both Termux and Debian passwords should be strong
   - Termux password: `passwd` (in Termux)
   - Debian root password: `passwd` (in Debian proot)
2. **Password authentication is enabled** - Convenient but less secure than keys
   - For better security, use SSH keys and disable password auth
3. **Static IP recommended** - Makes blocking unauthorized access easier
4. **Firewall rules** - Consider which devices can access your phone
5. **Screen lock** - Boot scripts only run if phone is unlocked
6. **Battery drain** - SSH server uses minimal battery, but keep phone charged
7. **Network security** - Only connect to trusted WiFi networks

### Disable Password Authentication (Optional - Most Secure)

**Only do this AFTER setting up SSH keys!**

```bash
# Edit SSH config
nano $PREFIX/etc/ssh/sshd_config
```

Find and change:
```
PasswordAuthentication no
PubkeyAuthentication yes
```

Save and restart SSH:
```bash
pkill sshd
sshd
```

**Important:** Test key-based login works BEFORE disabling passwords, or you could lock yourself out!

### Restrict Access by IP

```bash
# Allow only specific IPs
nano $PREFIX/etc/ssh/sshd_config
```

Add:
```
AllowUsers *@192.168.1.0/24
```

This only allows connections from your local network.

## Troubleshooting

### SSH Server Not Starting on Boot

**Check 1:** Did you open Termux:Boot app once?
```bash
# Open Termux:Boot app, it should show:
# "Termux:Boot scripts are enabled"
```

**Check 2:** Is the script executable?
```bash
ls -l ~/.termux/boot/start-sshd.sh
# Should show: -rwx------
```

**Check 3:** Check the log
```bash
cat ~/sshd-boot.log
# Should show boot timestamps and IP
```

**Check 4:** Is phone unlocked?
- Boot scripts only run if phone is unlocked after boot
- Lock screen prevents script execution

### Can't Connect to SSH

**Check 1:** Is sshd running?
```bash
ps aux | grep sshd
# Should show: /data/data/com.termux/files/usr/bin/sshd
```

**Check 2:** Check port
```bash
# SSH in Termux uses port 8022, not 22
ssh -p 8022 192.168.1.100
```

**Check 3:** Check firewall/network
```bash
# From your computer, ping the phone
ping 192.168.1.100

# Try telnet to check port
telnet 192.168.1.100 8022
```

**Check 4:** Check authentication
```bash
# On phone - verify password is set
passwd
# Will ask for current password if one exists

# Or check SSH keys if using key auth
cat ~/.ssh/authorized_keys
# Should contain your computer's public key

# Check SSH config
grep -E "PasswordAuthentication|PubkeyAuthentication" $PREFIX/etc/ssh/sshd_config
# Should show both enabled
```

### Phone IP Changes

If your IP keeps changing:
1. Set a static IP (see above)
2. Or use dynamic DNS service
3. Or find IP from log: `cat ~/sshd-boot.log`

## Battery Life

SSH server running in background uses **minimal battery**:
- ~1-2% per hour (idle)
- ~5-10% per hour (active transfers)

**Tips to minimize drain:**
- Keep phone plugged in if using 24/7
- Close SSH connections when not in use
- Use Wake Lock to prevent sleep (if needed)

## Using Wake Lock (Optional)

To prevent Android from sleeping and closing connections:

```bash
# Install Termux:Wake-Lock
# From F-Droid: https://f-droid.org/packages/com.termux.wake.lock/

# In your boot script, add:
termux-wake-lock
```

**Warning:** This will increase battery drain significantly. Only use if you need 24/7 accessibility.

## Example Use Cases

### Remote Development
```bash
# SSH from laptop to phone
ssh galaxyj7

# Edit code
cd ~/projects-sd
vim myproject.py

# Run code on phone
python myproject.py
```

### Remote File Management
```bash
# Copy files to phone via SCP
scp -P 8022 backup.tar.gz galaxyj7:~/backup-sd/

# Copy files from phone
scp -P 8022 galaxyj7:~/photos/*.jpg ~/Desktop/
```

### Remote Command Execution
```bash
# Run commands without interactive session
ssh galaxyj7 'df -h'
ssh galaxyj7 'top -n 1'
ssh galaxyj7 'pkg upgrade'
```

### Access Debian Remotely
```bash
# SSH to Termux, then enter Debian
ssh galaxyj7
proot-distro login debian

# Or one-liner
ssh galaxyj7 -t 'proot-distro login debian'
```

## Monitoring and Logs

### Check SSH Activity

```bash
# View who's connected
who

# View active SSH sessions
ps aux | grep sshd

# View SSH logs
logcat | grep sshd
```

### Boot Log Analysis

```bash
# View all boot attempts
cat ~/sshd-boot.log

# View last boot
tail -2 ~/sshd-boot.log

# Clear old logs
> ~/sshd-boot.log
```

## Uninstalling

To disable auto-start:

```bash
# Remove boot script
rm ~/.termux/boot/start-sshd.sh

# Or disable Termux:Boot entirely
# Uninstall Termux:Boot app from phone
```

## Next Steps

After setting up auto-start SSH:

1. **Set up SSH keys** for password-free access
2. **Configure static IP** for consistent connection
3. **Test reboot** to ensure it works
4. **Add to SSH config** on your computer for easy access
5. **Consider Wake Lock** if you need 24/7 access

---

**Your Galaxy J7 is now a remote-accessible Linux box!**

Connect anytime with: `ssh -p 8022 <YOUR_PHONE_IP>`
