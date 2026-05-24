# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.4.2] - 2026-05-24

### Added
- **VNC Auto-Start on Boot** - VNC can now automatically start when phone boots
  - Updated boot script: `start-ssh-and-vnc-servers.sh`
  - Auto-start helper script: `update_boot_with_vnc.sh`
  - VNC starts on port 5901 automatically if desktop is installed
  - Runs in background with SSH servers
  - Complete setup script: `setup_vnc_complete.sh` for first-time VNC installation

### Changed
- **VNC_DESKTOP_GUIDE.md** - Added comprehensive auto-start section
  - Automated update instructions
  - Manual update instructions  
  - Testing and verification steps
  - Post-reboot behavior documentation
- **TERMUX_BOOT_SETUP.md** - Added VNC to auto-started services list
  - New section: "Adding VNC Auto-Start"
  - Integration with existing boot configuration
  - Links to VNC guide for complete setup

### Documentation
- **Quick VNC Setup Instructions** - Created quick_vnc_setup.txt for phone reference
- All VNC scripts now available in `/sdcard/Download/`

## [1.4.1] - 2026-05-24

### Added
- **VNC_DESKTOP_GUIDE.md** - Comprehensive VNC and desktop environment documentation
  - Complete installation instructions for TigerVNC
  - Step-by-step connection guide for all platforms (Windows, Mac, Linux, Android, iOS)
  - Recommended VNC clients for each platform
  - Desktop usage instructions (file manager, terminal, applications)
  - Comprehensive troubleshooting section
  - Advanced configuration (resolution, password, multiple displays, SSH tunneling)
  - Performance optimization tips
  - Security recommendations
  - Quick reference commands

### Changed
- **MINIMAL_SETUP_GUIDE.md** - Added reference to VNC_DESKTOP_GUIDE.md
- **README.md** - Updated docs structure with VNC guide
- **FINAL_SETUP_COMPLETE.txt** - Added VNC guide to available guides list

### Fixed
- Documentation gap: VNC setup was in scripts but lacked comprehensive user guide
- README referenced non-existent DEBIAN_DESKTOP_COMPLETE.md, now replaced with VNC_DESKTOP_GUIDE.md

## [1.4.0] - 2026-05-24

### Added
- **Minimal Setup Scripts** - New streamlined installation path
  - `scripts/install_minimal_apps.sh` - Essential Termux setup (~100MB)
    - Core utilities (grep, sed, awk)
    - termux-auth for passwd command
    - Git, Vim, curl, wget
    - OpenSSH and htop
    - proot-distro for Linux containers
  - `scripts/install_desktop_minimal.sh` - Minimal desktop setup
    - LXDE desktop environment only (~400MB)
    - VNC server (TigerVNC)
    - Auto-generated start/stop scripts
    - htop for system monitoring
- **Comprehensive Documentation**
  - `docs/MINIMAL_SETUP_GUIDE.md` - Complete minimal setup guide
    - Three setup paths: Minimal (~100MB), +Debian (~250MB), +Desktop (~650MB)
    - Storage requirement breakdowns
    - Alternative to full ~1.2GB installation
    - Quick commands reference
  - `docs/TERMUX_BOOT_SETUP.md` - Complete Termux:Boot guide
    - Installation troubleshooting (signature mismatch, storage issues)
    - Storage cleanup procedures
    - Boot script configuration
    - Alternative auto-start methods
    - Security best practices
    - Comprehensive troubleshooting section
- **Termux:Boot Support** - Auto-start SSH servers on boot
  - Successfully installed Termux:Boot v0.8.1
  - Boot scripts created in `~/.termux/boot/`
  - Logs to `~/ssh-boot.log`
  - Starts both Termux and Debian SSH servers automatically
  - One-time activation required (open app after install)
- **htop Monitoring** - System monitor for both environments
  - Included in minimal setup scripts
  - Available in both Termux and Debian
  - Real-time process and resource monitoring

### Changed
- **README.md** - Major reorganization
  - Added "Choose Your Setup Path" section
  - Four clear options: Minimal, +Debian, +Desktop, Everything
  - Updated repository structure with new files
  - Better organization for different use cases
- **Installation philosophy** - Progressive enhancement
  - Start minimal, add only what you need
  - Clear storage requirements at each level
  - Modular script approach

### Fixed
- **Storage space management** for Termux:Boot installation
  - Cleaned Chrome and Play Store caches
  - Uninstalled Google Photos and Gmail (freed ~19MB)
  - Uninstalled additional Samsung bloat
  - Freed space from 448MB to 502MB available
- **Termux:Boot signature compatibility**
  - Downloaded correct GitHub-signed version matching Termux
  - Resolved INSTALL_FAILED_SHARED_USER_INCOMPATIBLE error
  - Successfully installed 727KB APK
- **proot installation** after reboot
  - Documented in minimal setup script
  - Included in essential package list

### Technical Details
- **Termux:Boot version**: v0.8.1 (June 22, 2024)
- **Installation size**: 727KB APK
- **Boot script location**: `~/.termux/boot/start-ssh-servers.sh`
- **Log file**: `~/ssh-boot.log`
- **Network wait time**: 10 seconds for WiFi/cellular to initialize
- **Background process**: Debian SSH runs with `&` to not block

## [1.3.0] - 2026-05-24

### Added
- **SSH Authentication Choice** in `setup_ssh_autostart.sh`
  - Interactive prompt for authentication method:
    1. SSH keys only (RECOMMENDED - most secure)
    2. Password only (less secure, but simpler)
    3. Both password and keys (convenient)
  - Defaults to keys-only for maximum security
  - Different setup instructions based on user choice
  - Addresses security concern of forced password authentication
- **Code of Conduct** (`CODE_OF_CONDUCT.md`)
  - Contributor Covenant v1.4
  - Community standards for FlossWare organization
  - Harassment-free environment pledge

### Fixed
- **All 28 GitHub issues resolved** across 3 review cycles
  - Critical: Removed corrupted hackerskeyboard.apk, verified APKs not in repo
  - High Priority: bc→awk replacement, GPS disable protection, restore validation
  - Documentation: Removed duplicates, fixed references, added script type explanations
  - Security: SSH authentication now user-choice, not forced
- **Hard-coded storage references** removed from README
  - Changed "81GB SD card" → "SD card" (generic)
  - Removed "81GB free" → dynamically detected in scripts
- **Python version detection** in `demo_hello_world.py`
  - Changed from hard-coded '3.x' to `sys.version.split()[0]`
  - Now shows actual Python version (e.g., "3.11.2")
- **GPS/location disable** in `aggressive_debloat.sh`
  - Now commented out with warning by default
  - Users must explicitly uncomment to disable location
  - Prevents accidental GPS breakage
- **Package validation** in `restore_all.sh`
  - Now checks if packages exist before enabling
  - Graceful handling across J7 variants
  - Consistent with aggressive_debloat.sh approach
- **Termux path portability** in scripts
  - Use `$PREFIX` and `$HOME` instead of hard-coded paths
  - More portable across Android versions
- **CHANGELOG duplicate section** removed
  - Cleaned up duplicate v1.1.0 content
  - Clear chronological order maintained
- **Documentation references** updated
  - Removed references to non-existent files
  - Added "Script Types" section explaining shebangs
- **Demo scripts** visual fixes
  - Fixed unclosed box border in `demo_system_monitor.sh`

### Changed
- **Security-first defaults** throughout
  - SSH now defaults to key-only authentication
  - Password authentication is opt-in with warnings
  - Strong password requirements emphasized
- **Contributing section** expanded in README
  - Added hardware testing requirements
  - Documentation update guidelines
  - Code style consistency notes
  - Camera verification requirements
- **License clarification**
  - Fixed README (was "MIT", actual is GPL-3.0)
  - Consistent license references throughout

### Improved
- Better user experience with informed security choices
- More accurate documentation (no hard-coded device-specific values)
- Production-ready code quality with 28 issues resolved
- Professional open-source project standards

## [1.2.0] - 2026-05-23

### Added
- **SSH Auto-Start on Boot** (`setup_ssh_autostart.sh` + `AUTO_START_SSH.md`)
  - Automatically start SSH server when phone boots
  - Requires Termux:Boot app (from F-Droid)
  - Turn Galaxy J7 into 24/7 accessible remote Linux box
  - Includes security guide, configuration examples, troubleshooting
  - Battery-efficient background operation
- **Prerequisite checker script** (`check_prerequisites.sh`)
  - Validates ADB connection before running scripts
  - Checks device model and Android version
  - Detects Termux installation status
  - Verifies SD card presence and available space
  - Provides warnings for non-J7 devices
- **Device compatibility section** in README
  - Lists known J7 variants (Prime, Pro, 2017, Sky Pro, Perx)
  - Explains differences between carrier variants
  - Warns about package name differences

### Fixed
- **SD card symlink creation** in `setup_termux_sdcard.sh`
  - Now creates actual symlinks instead of directories
  - Auto-detects SD card path (external-1 or external-2)
  - Verifies symlinks were created successfully
  - Shows available space on SD card
- **Error handling** in `aggressive_debloat.sh`
  - Checks ADB connection before starting
  - Gracefully handles missing packages (device-specific bloat)
  - Shows which packages were disabled vs skipped
  - Prevents errors when package doesn't exist
- **Validation** in `install_debian_with_ssh.sh`
  - Checks if proot-distro is installed (auto-installs if missing)
  - Verifies SD card is configured before installation
  - Warns if less than 1GB free space
  - Detects existing Debian installations
  - Verifies installation succeeded before continuing
  - Shows final installation size

### Changed
- All scripts now handle fresh Galaxy J7 devices correctly
- Scripts skip missing packages instead of failing
- Better error messages throughout
- Repository ownership transferred to FlossWare organization

### Improved
- Scripts are now portable across J7 variants
- Better user feedback during script execution
- More robust against device-specific differences

## [1.1.0] - 2026-05-21

### Added
- **Full Debian Linux environment** via proot-distro
  - Debian Trixie (latest stable)
  - ~687MB installation on SD card
  - Full apt package manager with 1000s of packages
  - Isolated Linux environment (no root required)
- **OpenSSH Server**
  - OpenSSH 10.0p1-7 with server and client
  - SSH, SFTP, and SCP support
  - RSA, ECDSA, and ED25519 keys generated
  - Remote access to phone from any device
- **SD Card Storage Configuration**
  - `setup_termux_sdcard.sh` - Configure Termux to use SD card
  - 81GB free SD card space for projects
  - Symlinks for projects, downloads, scripts, backups
  - Linux distributions stored on SD card
- **New Scripts**
  - `install_debian_with_ssh.sh` - Automated Debian + OpenSSH installer
  - `setup_termux_sdcard.sh` - SD card storage configuration
- **New Documentation**
  - `TERMUX_DEBIAN_GUIDE.md` - Complete 300+ line guide
  - Covers installation, configuration, SSH setup, troubleshooting
  - Common tasks: web servers, databases, Git, development
  - Security best practices
- **Auto-start Management**
  - Restricted background running for user apps
  - Only Weather and Nova Launcher auto-start
  - All other apps (Authy, Firefox, KDE Connect, etc.) run on-demand
  - Saves battery and RAM

### Changed
- Updated README.md with Debian/SSH sections
- Increased disabled packages from 77 to **92** (39% reduction)
- Added cellular services back (minimal impact without SIM card)
- Repository structure updated to include new scripts and docs
- Statistics updated:
  - Files: 20 → 25+
  - Lines of code: 1000+ → 2000+
  - SD card: 80GB+ available for projects

### Fixed
- Termux proot-distro now correctly uses SD card storage
- OpenSSH installation automated in Debian
- Resolved Python SSL certificate issues during installation
- Background app restrictions properly configured

### Security
- OpenSSH configured with secure defaults
- SSH keys automatically generated on install
- Documentation on key-based authentication
- Security hardening guide included

## [1.0.0] - 2026-05-21

### Added
- Initial release of Galaxy J7 Mini Computer conversion project
- Aggressive debloat script removing 70 bloatware packages
- Safe debloat scripts (phase 1 and phase 2)
- Emergency restore script
- Comprehensive Termux setup script
- F-Droid and Termux APK installers
- Three demo projects:
  - Python web server (demo_hello_world.py)
  - File organizer (demo_file_organizer.py)
  - System monitor (demo_system_monitor.sh)
- Complete documentation:
  - README.md
  - TERMUX_QUICK_START.md
  - mini_computer_setup_guide.md
  - mini_computer_conversion_summary.md
  - samsung_j7_bloatware_removal.md
  - storage_and_bloatware_report.md

### Fixed
- Camera crash issue by reinstalling com.samsung.cmh package
- Protected critical camera dependencies from removal
- Verified camera saves photos to SD card

### Changed
- Reduced total packages from 235 to 165 (30% reduction)
- Removed all Verizon bloatware (9 packages)
- Removed 35+ Samsung bloatware packages
- Removed 11 unnecessary Google apps
- Optimized for performance and battery life

### Security
- Added camera package protection to prevent breakage
- Created emergency restore functionality
- Documented all safe-to-disable packages

## [Unreleased]

### Planned
- Support for other Samsung Galaxy J models
- Automated testing scripts
- Performance benchmarking tools
- Battery life comparison data
- More demo projects
- Video tutorial
- Additional Linux distributions (Ubuntu, Alpine, Arch)
