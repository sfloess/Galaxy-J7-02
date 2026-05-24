# SSH Remote Installation Guide

Complete guide for installing VNC, desktop environments, and all services remotely via SSH.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [SSH Key Setup](#ssh-key-setup)
- [Remote Installation](#remote-installation)
- [Troubleshooting](#troubleshooting)
- [Why SSH Keys vs Password](#why-ssh-keys-vs-password)

## Overview

You can install and configure everything on your phone **completely remotely** via SSH, without ever opening Termux on the phone.

**What you can do remotely:**
- ✅ Install VNC and desktop environments
- ✅ Configure SSH servers
- ✅ Set up auto-start on boot
- ✅ Manage all services
- ✅ Start/stop VNC server

**Why this is useful:**
- Install while phone is in another room
- No need to type on tiny phone keyboard
- Use your computer's clipboard for commands
- Monitor installation progress from your computer

## Prerequisites

**On your phone:**
- ✅ Termux installed
- ✅ SSH server running (even without password)
- ✅ Phone connected to same WiFi network

**On your computer:**
- ✅ SSH client (built-in on Linux/Mac, use PuTTY on Windows)
- ✅ SSH key pair (we'll create if needed)

## SSH Key Setup

### Why SSH Keys?

After a phone reboot, Termux's password authentication may not work because:
- `termux-auth` package needs to be installed first
- `passwd` command isn't available until packages are installed
- **But SSH key authentication works immediately!**

### Step 1: Check for Existing SSH Keys

**On your computer:**

```bash
# Check if you already have SSH keys
ls -la ~/.ssh/id_*

# If you see id_rsa.pub or id_ed25519.pub, you have keys
```

### Step 2: Create SSH Keys (If Needed)

**On your computer:**

```bash
# Create new SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Press Enter for default location
# Press Enter for no passphrase (or set one if you want)

# Display your public key
cat ~/.ssh/id_ed25519.pub
```

**For older systems without ed25519 support:**

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
cat ~/.ssh/id_rsa.pub
```

### Step 3: Add Your SSH Key to the Phone

**From your computer via ADB:**

```bash
# Get your phone's SSH directory ready
adb shell "run-as com.termux mkdir -p /data/data/com.termux/files/home/.ssh"
adb shell "run-as com.termux chmod 700 /data/data/com.termux/files/home/.ssh"

# Add your public key (replace with your actual key)
MY_KEY=$(cat ~/.ssh/id_ed25519.pub)
adb shell "echo '$MY_KEY' | run-as com.termux tee -a /data/data/com.termux/files/home/.ssh/authorized_keys"

# Set correct permissions
adb shell "run-as com.termux chmod 600 /data/data/com.termux/files/home/.ssh/authorized_keys"
```

### Step 4: Test SSH Connection

**Get your phone's IP address:**

```bash
adb shell "ip -4 addr show wlan0 | grep inet | awk '{print \$2}' | cut -d/ -f1"
```

**Test the SSH connection:**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "echo 'SSH works!' && pwd"
```

If you see `SSH works!` and the home directory path, you're ready!

## Remote Installation

### Option 1: Automated All-in-One Installation (Recommended)

This installs everything: SSH, VNC, desktop, auto-start.

**Step 1: Verify script is on phone**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "ls -la all_in_one_setup.sh"
```

If the script doesn't exist:

```bash
# Push it from your computer
adb push /sdcard/Download/all_in_one_setup.sh /sdcard/Download/
adb shell "run-as com.termux cp /sdcard/Download/all_in_one_setup.sh /data/data/com.termux/files/home/"
```

**Step 2: Run installation remotely**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash all_in_one_setup.sh"
```

This will:
- Install termux-auth, openssh, proot, proot-distro (~5 min)
- Install Debian Linux (~5 min)
- Install LXDE desktop (~8 min)
- Install TigerVNC server (~2 min)
- Configure VNC with password "cobbler"
- Create start/stop scripts
- Enable auto-start on boot

**Total time:** 15-20 minutes

You'll see the installation progress in your terminal.

### Option 2: Step-by-Step Remote Installation

If you want more control:

**Step 1: Install basic packages**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash -c '
export PATH=/data/data/com.termux/files/usr/bin:\$PATH
pkg update -y
pkg install -y termux-auth openssh proot proot-distro
'"
```

**Step 2: Install Debian**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash -c '
export PATH=/data/data/com.termux/files/usr/bin:\$PATH
proot-distro install debian
'"
```

**Step 3: Install desktop in Debian**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash -c '
export PATH=/data/data/com.termux/files/usr/bin:\$PATH
proot-distro login debian -- bash -c \"
export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y lxde-core tigervnc-standalone-server dbus-x11 htop
mkdir -p ~/.vnc
echo cobbler | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
cat > ~/.vnc/xstartup << EOF
#!/bin/sh
dbus-launch --exit-with-session startlxde &
EOF
chmod +x ~/.vnc/xstartup
\"
'"
```

**Step 4: Start VNC remotely**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash -c '
export PATH=/data/data/com.termux/files/usr/bin:\$PATH
proot-distro login debian -- vncserver :1 -geometry 1280x720 -depth 24
'"
```

### Option 3: Interactive SSH Session

For a more interactive experience:

```bash
# Connect to phone
ssh -p 8022 u0_a181@YOUR_PHONE_IP

# Now you're in Termux, run commands normally:
bash all_in_one_setup.sh

# Or manual installation:
pkg install -y proot proot-distro
proot-distro install debian
# ... etc
```

## Post-Installation

### Start VNC Remotely

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "bash start_desktop.sh"
```

### Stop VNC Remotely

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "bash stop_desktop.sh"
```

### Check VNC Status

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && proot-distro login debian -- vncserver -list"
```

### Enable Auto-Start on Boot

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "bash /sdcard/Download/update_boot_with_vnc.sh"
```

## Troubleshooting

### SSH Connection Refused

**Problem:** `Connection refused` when trying to SSH

**Solutions:**

1. **Check if SSH server is running:**
   ```bash
   adb shell "run-as com.termux pgrep -f sshd"
   ```

2. **Start SSH server:**
   ```bash
   adb shell "run-as com.termux /data/data/com.termux/files/usr/bin/sshd"
   ```

3. **Verify phone IP:**
   ```bash
   adb shell "ip addr show wlan0 | grep inet"
   ```

### Permission Denied (publickey)

**Problem:** SSH says "Permission denied (publickey)"

**Solutions:**

1. **Verify your key is on the phone:**
   ```bash
   adb shell "run-as com.termux cat /data/data/com.termux/files/home/.ssh/authorized_keys"
   ```

2. **Re-add your key:**
   ```bash
   MY_KEY=$(cat ~/.ssh/id_ed25519.pub)
   adb shell "echo '$MY_KEY' | run-as com.termux tee /data/data/com.termux/files/home/.ssh/authorized_keys"
   ```

3. **Check permissions:**
   ```bash
   adb shell "run-as com.termux chmod 600 /data/data/com.termux/files/home/.ssh/authorized_keys"
   adb shell "run-as com.termux chmod 700 /data/data/com.termux/files/home/.ssh"
   ```

### Command Not Found

**Problem:** `bash: pkg: command not found` or similar

**Solution:** Always set PATH in SSH commands:

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "/data/data/com.termux/files/usr/bin/bash -c '
export PATH=/data/data/com.termux/files/usr/bin:\$PATH
pkg install something
'"
```

Or add to SSH config file (`~/.ssh/config` on your computer):

```
Host galaxyj7
    HostName 192.168.1.248
    Port 8022
    User u0_a181
    RemoteCommand export PATH=/data/data/com.termux/files/usr/bin:$PATH; bash -l
```

Then connect with:
```bash
ssh galaxyj7
```

### Installation Fails Midway

**Problem:** Installation stops or errors out

**Check logs:**

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "cat vnc-install.log"
```

**Restart from where it failed:**

Most package installations are idempotent, so you can re-run:

```bash
ssh -p 8022 u0_a181@YOUR_PHONE_IP "bash all_in_one_setup.sh"
```

Already-installed packages will be skipped.

## Why SSH Keys vs Password?

### The Problem with Passwords After Reboot

After a phone reboot, Termux is in a minimal state:
- Package manager works (`pkg`)
- SSH server runs (if started by boot script)
- **But** `passwd` command doesn't exist yet
- Requires installing `termux-auth` package first

**Chicken-and-egg problem:**
- Can't SSH in with password → Can't install `termux-auth`
- Can't install `termux-auth` → Can't set password
- Can't set password → Can't SSH in

### SSH Keys Solve This

SSH key authentication:
- ✅ Works immediately after reboot
- ✅ No password needed
- ✅ More secure than passwords
- ✅ Can't be brute-forced
- ✅ Allows remote package installation

**Once you install via SSH:**
1. Connect with SSH keys (works immediately)
2. Install `termux-auth` remotely
3. Set password remotely
4. Now both SSH keys AND password work

## Advanced: SSH Config File

Create `~/.ssh/config` on your computer for easier access:

```
# Samsung Galaxy J7
Host j7
    HostName 192.168.1.248
    Port 8022
    User u0_a181
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

# Alias for running commands with proper PATH
Host j7-cmd
    HostName 192.168.1.248
    Port 8022
    User u0_a181
    IdentityFile ~/.ssh/id_ed25519
    RemoteCommand export PATH=/data/data/com.termux/files/usr/bin:$PATH; bash
```

**Usage:**

```bash
# Simple connection
ssh j7

# Run single command
ssh j7 "ls -la"

# Start VNC
ssh j7 "bash start_desktop.sh"

# Interactive with proper PATH
ssh j7-cmd
```

## Security Considerations

**SSH keys are more secure than passwords:**
- ✅ Can't be brute-forced
- ✅ Can be revoked without changing password
- ✅ Can use different keys for different computers
- ✅ Can add passphrase protection to the key itself

**Best practices:**

1. **Use a passphrase on your SSH key:**
   ```bash
   ssh-keygen -t ed25519 -C "email@example.com"
   # Enter a passphrase when prompted
   ```

2. **Only add keys you trust:**
   ```bash
   # Review keys on phone
   adb shell "run-as com.termux cat ~/.ssh/authorized_keys"
   ```

3. **Remove old/unused keys:**
   ```bash
   # Edit authorized_keys, remove unwanted lines
   ssh j7 "nano ~/.ssh/authorized_keys"
   ```

4. **Set a password too (after termux-auth is installed):**
   ```bash
   ssh j7 "passwd"
   ```

5. **Consider disabling password auth entirely:**
   ```bash
   ssh j7 "echo 'PasswordAuthentication no' >> /data/data/com.termux/files/usr/etc/ssh/sshd_config"
   ```

## Summary

**Remote installation via SSH:**
1. ✅ Set up SSH keys (one-time)
2. ✅ Run installation script remotely
3. ✅ Everything installs without touching phone
4. ✅ Manage services remotely forever

**Benefits:**
- No typing on tiny keyboard
- Monitor progress on big screen
- Copy/paste commands easily
- Phone can be anywhere on network
- More secure than password auth

**All documented scripts available in:**
- `/sdcard/Download/` on your phone
- `docs/` in the GitHub repository

---

**Your phone is now a fully remote-manageable Linux desktop!**
