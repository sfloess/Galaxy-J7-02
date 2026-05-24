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

### 2. Install OpenSSH in Termux

```bash
# In Termux
pkg install openssh
```

### 3. Configure SSH Keys

```bash
# Generate SSH keys (if not already done)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Set up authorized_keys for remote access
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your public key from your computer
# Copy your computer's public key and paste it:
# cat ~/.ssh/id_rsa.pub (on your computer)
# Then paste into ~/.ssh/authorized_keys (on phone)
```

### 4. Create Boot Script

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

### 5. Grant Boot Permission

On your phone:
1. Open **Termux:Boot** app once (this is required!)
2. Android will ask for permission to run on boot - **Allow**
3. Close Termux:Boot

### 6. Test It

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

```bash
# Connect from another device
ssh -p 8022 192.168.1.XXX

# Or use username
ssh -p 8022 u0_a123@192.168.1.XXX
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

### Password-Free SSH Access

On your **computer** (not phone):

```bash
# Copy your public key to phone
ssh-copy-id -p 8022 192.168.1.100

# Now you can connect without password
ssh -p 8022 192.168.1.100
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

```bash
# Edit the boot script
nano ~/.termux/boot/start-sshd.sh
```

Add this:

```bash
#!/data/data/com.termux/files/usr/bin/bash

# Wait for network
sleep 10

# Start Termux SSH server
sshd

# Start Debian and its SSH server
proot-distro login debian -- bash -c "
    /etc/init.d/ssh start
    echo 'Debian SSH started on port 22 (inside proot)'
" &

# Log
echo "$(date): Termux SSH (port 8022) and Debian SSH (port 22) started" >> ~/sshd-boot.log
echo "IP: $(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')" >> ~/sshd-boot.log
```

**Note:** Debian SSH runs on port 22 but **only inside the proot environment**. To access it, first SSH into Termux, then enter Debian.

## Security Considerations

### ⚠️ Important Security Notes

1. **Use SSH keys, not passwords** - Password authentication is less secure
2. **Static IP recommended** - Makes blocking unauthorized access easier
3. **Firewall rules** - Consider which devices can access your phone
4. **Screen lock** - Boot scripts only run if phone is unlocked
5. **Battery drain** - SSH server uses minimal battery, but keep phone charged

### Disable Password Authentication

```bash
# Edit SSH config
nano $PREFIX/etc/ssh/sshd_config
```

Find and change:
```
PasswordAuthentication no
PubkeyAuthentication yes
```

Restart SSH:
```bash
pkill sshd
sshd
```

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

**Check 4:** Check SSH keys
```bash
# On phone
cat ~/.ssh/authorized_keys
# Should contain your computer's public key
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
