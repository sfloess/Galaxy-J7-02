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
| **Storage Available** | Limited | **81GB SD card** | **✅ Configured** |

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

Apps are pre-downloaded in this repo:

```bash
adb install apps/F-Droid.apk
adb install apps/termux.apk
```

Or download fresh copies:
- [F-Droid](https://f-droid.org/)
- [Termux](https://github.com/termux/termux-app/releases)

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

This creates symlinks to use your SD card (81GB free) for:
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

**Access your phone remotely:**

```bash
# From any device on your network
ssh -p 8022 <YOUR_PHONE_IP>
```

See `docs/AUTO_START_SSH.md` for complete SSH auto-start guide.

## 📁 Repository Structure

```
Samsung-Galaxy-J7/
├── README.md                          # This file
├── docs/                              # Documentation
│   ├── AUTO_START_SSH.md             # ⭐ NEW: Auto-start SSH server on boot
│   ├── DEBLOAT_SUMMARY.txt           # Bloatware removal summary
│   ├── FINAL_SETUP_COMPLETE.txt      # Complete setup guide
│   ├── TERMUX_QUICK_START.md         # Termux quick reference
│   ├── TERMUX_DEBIAN_GUIDE.md        # Debian + SSH complete guide
│   ├── mini_computer_setup_guide.md  # Usage guide
│   ├── mini_computer_conversion_summary.md  # Detailed report
│   ├── samsung_j7_bloatware_removal.md     # Bloatware reference
│   ├── storage_and_bloatware_report.md     # Storage analysis
│   └── install_termux_fdroid.md      # Installation guide
├── scripts/                           # All scripts
│   ├── check_prerequisites.sh        # ⭐ Check device compatibility
│   ├── aggressive_debloat.sh         # Main debloat script (improved error handling)
│   ├── setup_ssh_autostart.sh        # ⭐ NEW: Auto-start SSH on boot
│   ├── safe_bloatware_removal.sh     # Conservative debloat
│   ├── disable_bloatware.sh          # Phase 1 removal
│   ├── disable_more_bloatware.sh     # Phase 2 removal
│   ├── restore_all.sh                # Emergency restore
│   ├── termux_setup.sh               # Termux installer
│   ├── setup_termux_sdcard.sh        # SD card configuration (fixed symlinks)
│   └── install_debian_with_ssh.sh    # Debian + OpenSSH installer (added validation)
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

- **Files Created:** 25+
- **Lines of Code:** 2000+
- **Packages Removed:** 92 (Android bloatware)
- **Setup Time:** ~15 minutes (includes Debian)
- **Disk Space Freed:** ~500MB internal storage
- **SD Card Used:** ~700MB (Debian with OpenSSH)
- **SD Card Free:** 80GB+ for projects

## 🤝 Contributing

This project documents my personal Galaxy J7 conversion. Feel free to:
- Fork for your own device
- Submit issues for problems
- Share improvements via pull requests
- Add support for other Samsung models

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

This project is released under the MIT License. See LICENSE file for details.

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

Last Updated: 2026-05-21
