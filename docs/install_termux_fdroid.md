# Installing Termux & F-Droid - Complete Guide

> **💡 Looking for the full setup guide?** After installing Termux, see:
> - **[MINIMAL_SETUP_GUIDE.md](MINIMAL_SETUP_GUIDE.md)** - Streamlined setup paths
> - **[TERMUX_QUICK_START.md](TERMUX_QUICK_START.md)** - Full feature setup
>
> This guide covers just the **Termux installation** process.

## Step 1: Install F-Droid (App Store)

### Method 1: Download via ADB (Easiest)
```bash
# Download F-Droid APK
cd /home/sfloess/tmp/adb
wget https://f-droid.org/F-Droid.apk

# Install to phone
adb install F-Droid.apk
```

### Method 2: Download on Phone
1. Open Firefox on your phone
2. Go to: https://f-droid.org/
3. Tap "Download F-Droid"
4. Open the downloaded APK and install
5. Enable "Install from Unknown Sources" if prompted

---

## Step 2: Install Termux

### Option A: Via F-Droid (Recommended)
1. Open F-Droid app
2. Search for "Termux"
3. Install "Termux" (main app)
4. Also install:
   - Termux:API (for Android integration)
   - Termux:Widget (for home screen shortcuts)
   - Termux:Styling (for themes)

### Option B: Direct APK Install
```bash
# Download latest Termux from GitHub
cd /home/sfloess/tmp/adb
wget https://github.com/termux/termux-app/releases/latest/download/termux-app_v0.118.0+github-debug_universal.apk

# Install
adb install termux-app_v*.apk
```

---

## Step 3: First-Time Termux Setup

Once Termux is installed, run these commands in Termux:

### Update Package Lists
```bash
pkg update && pkg upgrade -y
```

### Grant Storage Access
```bash
termux-setup-storage
```
(Tap "Allow" when prompted)

### Install Essential Tools
```bash
pkg install -y \
  git \
  vim \
  curl \
  wget \
  openssh \
  python \
  nodejs \
  htop \
  ncdu \
  tree
```

---

## Step 4: Configure Termux

### Create directories
```bash
mkdir -p ~/bin ~/projects ~/scripts
```

### Set up SSH (optional but useful)
```bash
# Install SSH server
pkg install openssh -y

# Set password
passwd

# Start SSH server
sshd

# Get your IP address
ifconfig wlan0
```

### Create a welcome script
```bash
cat > ~/.bashrc << 'EOF'
# Termux custom configuration
echo "Welcome to Termux Mini Computer!"
echo "IP Address: $(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')"
echo ""

# Useful aliases
alias ll='ls -lah'
alias update='pkg update && pkg upgrade'
alias ..='cd ..'
alias projects='cd ~/projects'

# Show system info
neofetch 2>/dev/null || echo "Install neofetch: pkg install neofetch"
EOF

source ~/.bashrc
```

---

## Step 5: Verify Installation

Run these tests in Termux:

```bash
# Check Python
python --version

# Check Node.js
node --version

# Check Git
git --version

# List installed packages
pkg list-installed | wc -l
```

All should work without errors!

---

## Troubleshooting

**"Package not found"**
```bash
pkg update
pkg upgrade
```

**"Permission denied" when accessing storage**
```bash
termux-setup-storage
# Tap "Allow" when prompted
```

**Termux won't install**
- Make sure you're using F-Droid version or GitHub release
- Google Play Store version is outdated and broken
- Uninstall old version first if needed

**SSH server won't start**
```bash
# Check if already running
pgrep sshd

# Kill and restart
pkill sshd
sshd
```

---

## Next Steps After Installation

1. Install development tools (see next guide)
2. Set up your projects directory
3. Configure SSH for remote access
4. Install additional apps from F-Droid
5. Start coding!
