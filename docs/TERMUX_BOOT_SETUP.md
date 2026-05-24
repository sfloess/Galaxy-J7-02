# Termux:Boot Auto-Start Guide

Complete guide to automatically starting SSH servers on boot using Termux:Boot.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Alternative Methods](#alternative-methods)

## Overview

Termux:Boot is an official Termux add-on that runs scripts when your Android device boots up. This allows your SSH servers to start automatically without manual intervention.

**What gets auto-started:**
- ✅ Termux SSH server (port 8022)
- ✅ Debian SSH server (port 22, inside proot)
- ✅ VNC server (port 5901, optional - if desktop installed)

**Important:** Termux:Boot requires:
1. One-time app launch after installation
2. One-time app launch after each boot (first boot only)
3. Storage permissions granted to Termux

## Prerequisites

- ✅ Termux installed from F-Droid or GitHub
- ✅ SSH servers configured (Termux and optionally Debian)
- ✅ ~500MB free internal storage
- ✅ Termux storage access enabled (`termux-setup-storage`)

## Installation

### Step 1: Free Up Storage

Termux:Boot requires internal storage. If installation fails with "not enough space," free up storage first:

**From your computer:**

```bash
# Clear app caches
adb shell pm clear com.android.chrome
adb shell pm clear com.android.vending

# Uninstall unnecessary apps
adb shell pm uninstall --user 0 com.google.android.apps.photos
adb shell pm uninstall --user 0 com.google.android.gm
adb shell pm uninstall --user 0 com.vcast.mediamanager
```

### Step 2: Download Termux:Boot

**From your computer:**

```bash
# Download latest version
wget -O termux-boot.apk "https://github.com/termux/termux-boot/releases/download/v0.8.1/termux-boot-app_v0.8.1%2Bgithub.debug.apk"

# Verify download
ls -lh termux-boot.apk
# Should show ~700KB file
```

### Step 3: Install Termux:Boot

```bash
# Install via ADB
adb install termux-boot.apk
```

**Expected output:**
```
Performing Streamed Install
Success
```

**If you see an error:**

- **"INSTALL_FAILED_SHARED_USER_INCOMPATIBLE"**: Your Termux was installed from a different source. Download Termux:Boot from the same source (F-Droid or GitHub).
- **"not enough space"**: Free up more storage (see Step 1).

### Step 4: Grant Permissions

**On your phone:**

1. Open Termux
2. Run: `termux-setup-storage`
3. Grant storage permission when prompted

## Configuration

### Automated Setup Script (Recommended)

**From your computer:**

```bash
# Push the auto-start setup script
adb push scripts/setup_ssh_autostart.sh /sdcard/Download/
```

**On your phone in Termux:**

```bash
# Copy and run the setup script
cp /sdcard/Download/setup_ssh_autostart.sh ~/
bash ~/setup_ssh_autostart.sh
```

This script:
- Creates `~/.termux/boot/` directory
- Installs the auto-start script
- Configures SSH authentication (password or keys)
- Sets up logging

### Manual Setup

**On your phone in Termux:**

```bash
# Create boot scripts directory
mkdir -p ~/.termux/boot

# Create SSH auto-start script
cat > ~/.termux/boot/start-ssh-servers.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Auto-start SSH servers on boot

echo "$(date): Starting SSH servers..." >> ~/ssh-boot.log

# Wait for network
sleep 10

# Start Termux SSH
sshd >> ~/ssh-boot.log 2>&1
echo "$(date): Termux SSH started" >> ~/ssh-boot.log

# Start Debian SSH in proot (if Debian is installed)
if proot-distro list 2>/dev/null | grep -q "debian"; then
    proot-distro login debian -- bash -c "
        mkdir -p /run/sshd
        /usr/sbin/sshd -D >> /root/ssh-boot.log 2>&1
    " >> ~/ssh-boot.log 2>&1 &
    echo "$(date): Debian SSH started" >> ~/ssh-boot.log
fi

echo "$(date): Boot script complete" >> ~/ssh-boot.log
EOF

# Make executable
chmod +x ~/.termux/boot/start-ssh-servers.sh
```

### Activate Termux:Boot

**CRITICAL STEP:** Termux:Boot must be opened once to activate.

**On your phone:**

1. Open the Termux:Boot app from your app drawer
2. You'll see a simple screen confirming boot scripts will run
3. Exit the app (it doesn't need to stay open)

**That's it!** Your boot scripts will now run automatically.

## Testing

### Test 1: Verify Boot Script Exists

**In Termux:**

```bash
ls -la ~/.termux/boot/
```

**Expected output:**
```
-rwxrwx--x 1 u0_a181 u0_a181 490 2026-05-23 23:04 start-ssh-servers.sh
```

### Test 2: Reboot and Check Logs

**From your computer:**

```bash
# Reboot phone
adb reboot

# Wait for boot (60-90 seconds)
sleep 90

# Check if SSH is running
adb shell "run-as com.termux pgrep -f sshd"
```

**On your phone in Termux:**

```bash
# Check boot log
cat ~/ssh-boot.log
```

**Expected log output:**
```
Fri May 23 23:05:15 UTC 2026: Starting SSH servers...
Fri May 23 23:05:25 UTC 2026: Termux SSH started
Fri May 23 23:05:26 UTC 2026: Debian SSH started
Fri May 23 23:05:26 UTC 2026: Boot script complete
```

### Test 3: Connect via SSH

**From another device:**

```bash
# Find phone IP
# On phone in Termux: ifconfig wlan0 | grep inet

# Connect to Termux SSH
ssh -p 8022 u0_a181@YOUR_PHONE_IP
```

## Troubleshooting

### Auto-Start Not Working

**Problem:** SSH servers don't start after reboot.

**Solutions:**

1. **Check if Termux:Boot was opened:**
   - Open the Termux:Boot app on your phone
   - This activates the BOOT_COMPLETED receiver
   - Only needs to be done once after installation

2. **Check boot script exists:**
   ```bash
   ls -la ~/.termux/boot/
   ```

3. **Check boot log:**
   ```bash
   cat ~/ssh-boot.log
   ```

4. **Check Android logs:**
   ```bash
   # From computer
   adb logcat | grep -i termux
   ```

5. **Manually test the boot script:**
   ```bash
   bash ~/.termux/boot/start-ssh-servers.sh
   ```

### Permission Errors

**Problem:** "Permission denied" when accessing boot directory.

**Solution:**

```bash
# Re-run storage setup
termux-setup-storage

# Recreate boot directory
mkdir -p ~/.termux/boot
chmod 700 ~/.termux/boot
```

### SSH Not Starting

**Problem:** Boot script runs but SSH doesn't start.

**Solutions:**

1. **Check if sshd is installed:**
   ```bash
   which sshd
   pkg install openssh
   ```

2. **Check if password is set:**
   ```bash
   passwd
   ```

3. **Start SSH manually and check errors:**
   ```bash
   sshd -d
   ```

### Termux:Boot Installation Failed

**Problem:** "INSTALL_FAILED_SHARED_USER_INCOMPATIBLE"

**Cause:** Termux and Termux:Boot were built by different signing keys (F-Droid vs GitHub).

**Solution:** Install both from the same source:

- **If Termux is from F-Droid:** Download Termux:Boot from F-Droid
- **If Termux is from GitHub:** Download Termux:Boot from GitHub

**Check Termux source:**
```bash
adb shell dumpsys package com.termux | grep versionName
```

**GitHub versions:** Have "+github" in version name  
**F-Droid versions:** Plain version numbers

### Not Enough Storage

**Problem:** Installation fails with "not enough space"

**Solution:**

```bash
# Check available space
adb shell df -h /data

# Clear caches
adb shell pm clear com.android.chrome
adb shell pm clear com.android.vending

# Uninstall large apps
adb shell pm list packages -3  # List user apps
adb shell pm uninstall --user 0 PACKAGE_NAME
```

## Adding VNC Auto-Start

If you have VNC desktop installed, you can add it to auto-start on boot.

### Prerequisites

- ✅ Termux:Boot installed and configured
- ✅ Debian with desktop environment installed
- ✅ VNC server (TigerVNC) installed and working

### Quick Update (Recommended)

**On your phone in Termux:**

```bash
# Copy and run the update script
cp /sdcard/Download/update_boot_with_vnc.sh ~/
bash ~/update_boot_with_vnc.sh
```

This updates your boot script to include VNC auto-start.

### Manual Update

Replace your current boot script with the VNC-enabled version:

```bash
# Copy the updated script
cp /sdcard/Download/start-ssh-and-vnc-servers.sh ~/.termux/boot/

# Remove old script (if different name)
rm ~/.termux/boot/start-ssh-servers.sh 2>/dev/null

# Make executable
chmod +x ~/.termux/boot/start-ssh-and-vnc-servers.sh
```

### What Gets Auto-Started

After update, these services start on boot:
- ✅ Termux SSH (port 8022)
- ✅ Debian SSH (port 22 in proot)
- ✅ VNC server (port 5901)

### Test Without Rebooting

```bash
bash ~/.termux/boot/start-ssh-and-vnc-servers.sh
```

Check the log:
```bash
cat ~/ssh-boot.log
```

### After Reboot

1. Phone boots and unlocks (~30 seconds)
2. Services start automatically
3. VNC accessible at `YOUR_PHONE_IP:5901`
4. Password: `cobbler`

**Complete VNC setup guide:** See [VNC_DESKTOP_GUIDE.md](VNC_DESKTOP_GUIDE.md)

## Alternative Methods

If you cannot install Termux:Boot, here are alternatives:

### Method 1: Remote Start Script

Create a script on your computer to start SSH remotely:

```bash
# Create ~/start-j7-ssh.sh on your computer
cat > ~/start-j7-ssh.sh << 'EOF'
#!/bin/bash
# Start SSH servers on Samsung J7 remotely

echo "Starting SSH servers on Samsung J7..."

# Start Termux SSH
adb shell "run-as com.termux /data/data/com.termux/files/usr/bin/sshd"

# Start Debian SSH (if installed)
adb shell "run-as com.termux /data/data/com.termux/files/usr/bin/proot-distro login debian -- bash -c 'mkdir -p /run/sshd && /usr/sbin/sshd -D' &"

echo "✅ SSH servers started!"
echo "Connect: ssh -p 8022 u0_a181@YOUR_PHONE_IP"
EOF

chmod +x ~/start-j7-ssh.sh
```

**Usage:**

```bash
# After phone boots, run from your computer:
bash ~/start-j7-ssh.sh
```

### Method 2: Tasker Automation (Requires Tasker App)

1. Install Tasker from Play Store
2. Create a new Profile: **Event → System → Device Boot**
3. Create a new Task: **Termux → Termux Command**
4. Command: `sshd`

### Method 3: Manual Start Each Time

**On your phone in Termux after each boot:**

```bash
# Start Termux SSH
sshd

# Start Debian SSH (if installed)
proot-distro login debian -- /etc/init.d/ssh start &
```

Or create a quick-start script:

```bash
# Create shortcut
cat > ~/ssh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
sshd
proot-distro login debian -- /etc/init.d/ssh start & 2>/dev/null
echo "SSH servers started"
EOF
chmod +x ~/ssh

# Usage: just type "ssh" in Termux
./ssh
```

## Boot Script Reference

### Location

```
~/.termux/boot/
```

All executable scripts in this directory run automatically at boot.

### Script Requirements

- Must have shebang: `#!/data/data/com.termux/files/usr/bin/bash`
- Must be executable: `chmod +x script.sh`
- File name doesn't matter (any `.sh` file works)

### Execution Order

Scripts run in alphabetical order. To control order, prefix with numbers:

```
01-network-wait.sh
02-start-ssh.sh
03-start-services.sh
```

### Environment

Boot scripts run with:
- Working directory: `~` (Termux home)
- No user interaction (can't prompt for input)
- Limited network access initially (hence the `sleep 10`)

### Logging

Always log output for debugging:

```bash
#!/data/data/com.termux/files/usr/bin/bash
exec > ~/boot.log 2>&1

echo "Starting at $(date)"
# Your commands here
echo "Finished at $(date)"
```

## Best Practices

1. **Keep scripts simple** - Complex scripts may fail silently
2. **Add delays** - Network may not be ready immediately (`sleep 10`)
3. **Log everything** - Redirect output to log files
4. **Test manually first** - Run your script manually before trusting it on boot
5. **Check logs** - Review `~/ssh-boot.log` after boot
6. **Background long-running processes** - Use `&` for SSH servers

## Security Considerations

**Auto-starting SSH means your phone is always accessible on the network.**

Recommendations:

1. **Use SSH keys instead of passwords**:
   ```bash
   # On your computer, copy your public key
   cat ~/.ssh/id_ed25519.pub
   
   # On phone in Termux, add to authorized_keys
   mkdir -p ~/.ssh
   echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   
   # Disable password authentication
   echo "PasswordAuthentication no" >> $PREFIX/etc/ssh/sshd_config
   ```

2. **Change default SSH port** (if not using 8022):
   ```bash
   echo "Port 2222" >> $PREFIX/etc/ssh/sshd_config
   ```

3. **Use a strong password**:
   ```bash
   passwd
   # Use a complex password, not "cobbler"
   ```

4. **Monitor who connects**:
   ```bash
   # Check active SSH connections
   who
   
   # Check SSH logs
   cat $PREFIX/var/log/sshd.log
   ```

## Resources

- [Termux:Boot GitHub](https://github.com/termux/termux-boot)
- [Termux Wiki - Boot](https://wiki.termux.com/wiki/Termux:Boot)
- [Android Boot Receivers](https://developer.android.com/reference/android/content/Intent#ACTION_BOOT_COMPLETED)

---

**Summary:**
1. Install Termux:Boot APK
2. Run `bash ~/setup_ssh_autostart.sh` in Termux
3. Open Termux:Boot app once
4. Reboot and SSH servers start automatically
