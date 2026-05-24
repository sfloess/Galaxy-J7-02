# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
  - DEBLOAT_SUMMARY.txt
  - FINAL_SETUP_COMPLETE.txt

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
  - DEBLOAT_SUMMARY.txt
  - FINAL_SETUP_COMPLETE.txt

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
