# Samsung Galaxy J7 → Mini Computer Conversion

Complete guide and scripts to transform a Samsung Galaxy J7 (Verizon) into a minimal, bloat-free Android mini computer.

## 🎯 Project Goals

- ✅ Remove all Verizon and Samsung bloatware
- ✅ Keep camera fully functional
- ✅ Install Termux Linux environment
- ✅ Create a portable development workstation
- ✅ Maximize performance and battery life

## 📊 Results

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Total Packages | 236 | 144 enabled | **-39%** |
| Disabled Packages | 0 | 92 | **92 bloat removed** |
| Verizon Bloat | 9 apps | 0 apps | **-100%** |
| Samsung Bloat | Heavy | Minimal | **~40 removed** |
| Performance | Slow | Fast | **Significant** |
| Battery Life | Poor | Better | **Improved** |
| **Linux Environment** | None | **Full Debian** | **✅ Added** |
| **SSH Server** | None | **OpenSSH** | **✅ Added** |
| **Storage Available** | Limited | **SD card** | **✅ Configured** |

## ⚠️ Device Compatibility

### Tested Device
- **Model**: Samsung Galaxy J7 (SM-J727V)
- **Carrier**: Verizon
- **Android**: 8.1.0

### Other J7 Variants
These scripts **may work** on other Galaxy J7 models but with differences:

| Variant | Model | Notes |
|---------|-------|-------|
| J7 Prime | SM-G610F | Different bloat packages, unlocked |
| J7 Pro | SM-J730F | Different Samsung apps |
| J7 (2017) | SM-J727T | T-Mobile bloat instead of Verizon |
| J7 Sky Pro | SM-S737TL | TracFone/prepaid bloat |
| J7 Perx | SM-J727P | Sprint bloat (legacy) |

**Before running on a different variant:**
1. Run `scripts/check_prerequisites.sh` first
2. Review which packages will be disabled
3. Some packages may not exist (script will skip them)
4. Carrier-specific bloat will differ

### What Differs Between Variants
- **Carrier bloat**: Verizon, T-Mobile, AT&T, Sprint apps
- **Region-specific apps**: Some Samsung apps vary by country
- **Android version**: Scripts tested on 8.1.0, may work on 7.x-9.x

**Golden rule**: Test the camera immediately after debloating!

## 🚀 Quick Start

### Choose Your Setup Path

**Option 1: Minimal Setup** (~100MB) - Recommended for beginners  
Essential tools only: Termux + SSH + Git + htop  
📖 Guide: [docs/MINIMAL_SETUP_GUIDE.md](docs/MINIMAL_SETUP_GUIDE.md)  
🚀 **NEW:** [Remote install via SSH](docs/SSH_REMOTE_INSTALL.md) - no need to touch phone!

**Option 2: Minimal + Debian** (~250MB) - Recommended for developers  
Adds full Linux with apt package manager  
📖 Guide: [docs/MINIMAL_SETUP_GUIDE.md](docs/MINIMAL_SETUP_GUIDE.md)

**Option 3: Full Desktop Environment** (~650MB) - For remote desktop access  
Includes LXDE desktop + VNC server  
📖 Guide: [docs/MINIMAL_SETUP_GUIDE.md](docs/MINIMAL_SETUP_GUIDE.md)

**Option 4: Everything** (~1.2GB) - Maximum features  
All desktop environments (LXDE, FVWM, JWM) + VNC  
📖 Follow the complete guide below

---

## 📖 Complete Setup Guide

### 0. Check Prerequisites (NEW!)

**IMPORTANT**: Run this first on a fresh device:

```bash
bash scripts/check_prerequisites.sh
```

This validates:
- ADB connection
- Device model compatibility  
- Android version
- Termux installation status
- SD card presence and space
- USB debugging capabilities

### 1. Debloat the Device

Connect your phone via USB with ADB enabled:

```bash
# Run the aggressive debloat script
./scripts/aggressive_debloat.sh
```

**What it removes:**
- All Verizon carrier bloatware (9 packages)
- Samsung account/cloud services
- Samsung themes and customization
- Unnecessary Google apps
- Print services, VPN bloat, accessibility features

**What it keeps:**
- Camera and Gallery (fully functional)
- Phone and SMS
- Google Play Store and Services
- Core Android system
- WiFi, Bluetooth, and networking

### 2. Install Termux

Download and install from official sources:

**F-Droid** (open source app store):
- Download: https://f-droid.org/
- Install via: `adb install F-Droid.apk`

**Termux** (Linux terminal):
- Download: https://f-droid.org/packages/com.termux/
- Or: https://github.com/termux/termux-app/releases
- Install via: `adb install termux.apk`

**Hacker's Keyboard** (optional, better for terminal):
- Download: https://f-droid.org/packages/org.pocketworkstation.pckeyboard/
- Install via: `adb install hackerskeyboard.apk`

### 3. Setup Termux Environment

Push the setup script to your phone:

```bash
adb push scripts/termux_setup.sh /sdcard/Download/
```

On your phone, open Termux and run:

```bash
cp /sdcard/Download/termux_setup.sh ~
chmod +x ~/termux_setup.sh
~/termux_setup.sh
```

This installs:
- Python, Node.js, Git, SSH, Ruby, PHP, Go
- 30+ development tools
- Custom bash configuration
- Project directory structure

### 4. Configure SD Card Storage

```bash
adb push scripts/setup_termux_sdcard.sh /sdcard/Download/
```

In Termux:

```bash
cp /sdcard/Download/setup_termux_sdcard.sh ~
bash ~/setup_termux_sdcard.sh
```

This creates symlinks to use your SD card for:
- Projects and code
- Downloads
- Scripts
- Backups
- Linux distributions

### 5. Install Debian with OpenSSH

```bash
adb push scripts/install_debian_with_ssh.sh /sdcard/Download/
```

In Termux:

```bash
cp /sdcard/Download/install_debian_with_ssh.sh ~
bash ~/install_debian_with_ssh.sh
```

This installs:
- Full Debian Linux (Trixie)
- OpenSSH server and client
- All on SD card (~687MB)
- Ready for remote access

**Access Debian:**

```bash
# Enter Debian
proot-distro login debian

# Set root password
passwd

# Start SSH server
/etc/init.d/ssh start

# Exit Debian
exit
```

**Remote Access:**

```bash
# Find phone IP (in Termux)
ifconfig wlan0 | grep inet

# SSH from another device
ssh root@YOUR_PHONE_IP
```

See `docs/TERMUX_DEBIAN_GUIDE.md` for complete instructions.

### 6. Auto-Start SSH Server (Optional)

Make your phone accessible remotely 24/7:

```bash
adb push scripts/setup_ssh_autostart.sh /sdcard/Download/
```

In Termux:

```bash
cp /sdcard/Download/setup_ssh_autostart.sh ~
bash ~/setup_ssh_autostart.sh
```

Then install **Termux:Boot** from F-Droid to enable auto-start on boot.

**Set password and access remotely:**

```bash
# In Termux, set a password first
passwd

# From any device on your network
ssh -p 8022 <YOUR_PHONE_IP>
# Enter your password when prompted
```

**Features:**
- ✅ Password authentication enabled (set with `passwd`)
- ✅ SSH key authentication also supported
- ✅ Root login enabled in Debian
- ✅ Auto-starts on boot

See `docs/AUTO_START_SSH.md` for complete SSH auto-start guide.

## 📁 Repository Structure

```
Samsung-Galaxy-J7/
├── README.md                          # This file
├── docs/                              # Documentation
│   ├── SSH_REMOTE_INSTALL.md         # ⭐ NEW: Install everything remotely via SSH
│   ├── MINIMAL_SETUP_GUIDE.md        # ⭐ Minimal installation guide
│   ├── VNC_DESKTOP_GUIDE.md          # ⭐ Complete VNC/desktop guide
│   ├── TERMUX_BOOT_SETUP.md          # ⭐ Complete Termux:Boot guide
│   ├── AUTO_START_SSH.md             # Auto-start SSH server on boot
│   ├── TERMUX_DEBIAN_GUIDE.md        # Debian + SSH complete guide
│   ├── TERMUX_QUICK_START.md         # Termux quick reference
│   ├── DEBLOAT_SUMMARY.txt           # Bloatware removal summary
│   ├── FINAL_SETUP_COMPLETE.txt      # Complete setup guide
│   ├── mini_computer_setup_guide.md  # Usage guide
│   ├── mini_computer_conversion_summary.md  # Detailed report
│   ├── samsung_j7_bloatware_removal.md     # Bloatware reference
│   ├── storage_and_bloatware_report.md     # Storage analysis
│   └── install_termux_fdroid.md      # Installation guide
├── scripts/                           # All scripts
│   ├── install_minimal_apps.sh       # ⭐ NEW: Minimal Termux setup (100MB)
│   ├── install_desktop_minimal.sh    # ⭐ NEW: Minimal desktop setup (LXDE + VNC)
│   ├── check_prerequisites.sh        # Check device compatibility
│   ├── aggressive_debloat.sh         # Main debloat script
│   ├── setup_ssh_autostart.sh        # Auto-start SSH on boot
│   ├── safe_bloatware_removal.sh     # Conservative debloat
│   ├── disable_bloatware.sh          # Phase 1 removal
│   ├── disable_more_bloatware.sh     # Phase 2 removal
│   ├── restore_all.sh                # Emergency restore
│   ├── termux_setup.sh               # Full Termux installer
│   ├── setup_termux_sdcard.sh        # SD card configuration
│   ├── install_debian_with_ssh.sh    # Debian + OpenSSH installer
│   ├── start_desktop.sh              # Desktop launcher (auto-generated)
│   └── stop_desktop.sh               # Desktop stop script (auto-generated)
├── demos/                             # Demo projects
│   ├── demo_hello_world.py           # Python web server
│   ├── demo_file_organizer.py        # File organizer
│   └── demo_system_monitor.sh        # System monitor
└── backup/                            # Backups
    └── packages_enabled_before.txt   # Original package list
```

## 🛡️ Safety Features

### Camera Protection

The camera app requires these packages (NEVER disable):
- `com.samsung.cmh` - Camera Mode Handler (**CRITICAL**)
- `com.sec.android.app.camera` - Camera app
- `com.sec.android.gallery3d` - Gallery
- `com.samsung.android.provider.shootingmodeprovider` - Camera modes
- `com.sec.factory.camera` - Camera factory
- `com.samsung.android.providers.context` - Context provider
- `com.sec.android.daemonapp` - System daemon

### Emergency Restore

If something breaks:

```bash
./scripts/restore_all.sh
```

This re-enables all previously disabled packages.

## 📦 What Gets Removed

### Verizon Bloatware (9 packages)
- Verizon App Manager
- Verizon Device Management
- Verizon Messages+
- Verizon Cloud/Media Manager
- And more...

### Samsung Bloatware (35+ packages)
- Samsung Health
- Samsung Account/Cloud services
- Samsung Themes
- Smart View/Screen Mirroring
- Office Viewer
- Extra fonts
- And more...

### Google Bloatware (11 packages)
- Gmail (keeping Chrome)
- Google Photos
- Google Search
- Google TTS
- Sync adapters
- And more...

**Kept for functionality:**
- Google Play Store & Services
- Chrome browser
- Core Android system

## 💻 What You Can Do

### Development
- Write and test Python, JavaScript, PHP, Go, Ruby code
- Run local web servers (Flask, Django, Express, etc.)
- Full Debian Linux environment with apt package manager
- Install databases (PostgreSQL, MySQL, Redis)
- Mobile app development and testing
- Learn programming on the go

### Networking
- SSH into remote servers
- **Run SSH server on phone** (access from any device)
- **Full OpenSSH with key-based authentication**
- Network scanning with nmap
- Monitor network traffic
- Remote development via SSH

### System Administration
- **Full Debian environment** - practice Linux skills
- User management, permissions, services
- **Run web servers** (nginx, apache)
- Database administration
- Container-like environments with proot

### Automation
- File organization scripts
- Automated backups
- Task scheduling (cron)
- Android automation via Termux-API

### Learning
- Linux command line mastery
- Git version control
- Web development
- Server administration
- Ethical hacking tools
- DevOps practices

## 🎓 Demo Projects

### 1. Web Server (Python)
```bash
python demos/demo_hello_world.py
# Visit http://localhost:8080
```

Demonstrates:
- HTTP server with multiple endpoints
- JSON API
- HTML templating
- Request handling

### 2. File Organizer (Python)
```bash
python demos/demo_file_organizer.py ~/Downloads
```

Demonstrates:
- File system operations
- Pattern matching
- Directory management
- Automation scripts

### 3. System Monitor (Bash)
```bash
./demos/demo_system_monitor.sh
```

Demonstrates:
- Real-time system stats
- Process monitoring
- Resource usage
- Shell scripting

## 📱 Device Specifications

**Device:** Samsung Galaxy J7 (SM-J727V)  
**Carrier:** Verizon  
**Android:** 8.1.0  
**Storage:** 10GB internal + SD card (119GB)  
**Camera:** Working ✅  

## ⚙️ Requirements

- Samsung Galaxy J7 (tested on J727V, may work on other models)
- ADB installed on computer
- USB debugging enabled on phone
- USB cable
- Linux/macOS computer (scripts use bash)

## 📝 Script Types

The repository contains two types of scripts designed for different environments:

### Computer Scripts (Run via ADB)
These scripts run on your **computer** and use ADB to communicate with the phone:
- **Shebang**: `#!/bin/bash`
- **Examples**: `aggressive_debloat.sh`, `restore_all.sh`, `check_prerequisites.sh`
- **How to run**: Execute directly from your computer's terminal
- **Purpose**: Debloating, package management, prerequisite checks

### Termux Scripts (Run on Phone)
These scripts run directly in **Termux** on your phone:
- **Shebang**: `#!/data/data/com.termux/files/usr/bin/bash`
- **Examples**: `termux_setup.sh`, `install_debian_with_ssh.sh`, `setup_termux_sdcard.sh`
- **How to run**: Copy to phone via `adb push`, then execute in Termux terminal
- **Purpose**: Termux setup, Debian installation, SSH configuration

**Why different shebangs?**  
Computer scripts use the standard system bash (`/bin/bash`), while Termux scripts use the Termux-specific bash location. This is normal and expected.

## 🔧 Advanced Usage

### Custom Debloat

Edit `scripts/aggressive_debloat.sh` to customize what gets removed.

Check safe-to-disable packages in:
```
docs/samsung_j7_bloatware_removal.md
```

### Termux Customization

The setup script creates:
- `~/.bashrc` - Custom bash configuration
- `~/bin/` - Custom executables
- `~/projects/` - Your projects
- `~/scripts/` - Utility scripts

### SSH Access

From your phone (in Termux):
```bash
sshd
ifconfig wlan0 | grep "inet "
```

From your computer:
```bash
ssh -p 8022 [username]@[phone-ip]
```

## 🐛 Troubleshooting

### Camera Crashes
```bash
# Reinstall critical package
adb shell cmd package install-existing com.samsung.cmh
adb shell pm clear com.sec.android.app.camera
```

### Restore Everything
```bash
./scripts/restore_all.sh
```

### Check What's Disabled
```bash
adb shell pm list packages -d
```

### Re-enable a Package
```bash
adb shell pm enable PACKAGE_NAME
```

## 📊 Statistics

- **Files Created:** 30+
- **Lines of Code:** 2500+
- **Documentation Pages:** 13
- **Packages Removed:** 92 (Android bloatware)
- **Setup Time:** 
  - Minimal: ~5 minutes (~100MB)
  - With Debian: ~10 minutes (~250MB)
  - With Desktop: ~20 minutes (~650MB)
  - Full Everything: ~45 minutes (~1.2GB)
- **Disk Space Freed:** ~500MB internal storage
- **SD Card Options:**
  - Minimal: ~100MB
  - + Debian: ~250MB
  - + Desktop (LXDE): ~650MB
  - + All Desktops (LXDE, FVWM, JWM): ~1.2GB
- **SD Card Free:** 80GB+ for projects

## 🤝 Contributing

Contributions are welcome! This project is open source and we'd love your help.

### How to Contribute

- Fork for your own device
- Submit issues for problems or questions
- Share improvements via pull requests
- Add support for other Samsung models
- Improve documentation
- Test on different J7 variants

### Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to sfloess@nc.rr.com.

### Guidelines

- Test your changes on actual hardware when possible
- Update documentation for any new features
- Follow existing code style
- Include comments for complex operations
- Verify camera still works after debloat changes

## ⚠️ Disclaimer

- **Backup your data** before running any scripts
- Test camera immediately after debloating
- Some features may break - be prepared to restore
- Not responsible for bricked devices
- Use at your own risk

## 📚 Additional Resources

- [Termux Wiki](https://wiki.termux.com/)
- [F-Droid](https://f-droid.org/)
- [ADB Documentation](https://developer.android.com/studio/command-line/adb)
- [XDA Developers Forum](https://forum.xda-developers.com/)

## 📝 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**FlossWare**

- GitHub: [@FlossWare](https://github.com/FlossWare)
- Project: [Samsung-Galaxy-J7](https://github.com/FlossWare/Samsung-Galaxy-J7)

## 🎉 Acknowledgments

- Claude Code for automation assistance
- Termux team for amazing Android Linux environment
- F-Droid community for open source apps
- XDA community for Android debloating knowledge

---

**Made with ❤️ by someone who wanted a mini computer in their pocket**

Last Updated: 2026-05-24
