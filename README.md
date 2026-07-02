# Samsung Galaxy J7 Fleet Worker Nodes

Transform Samsung Galaxy J7 phones into autonomous fleet worker nodes using Termux.

## Quick Status

**Phones:** android-j7-01 (✅ working), android-j7-02 (pending)  
**Auto-start:** SSH + Worker daemon + Fleet registration  
**Network:** WiFi (192.168.1.248)  
**Ports:** 8022 (SSH), 9003 (Worker HTTP API)

## Quick Start - Fleet Worker Setup

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete fleet worker setup.

**TL;DR:**
1. Install Termux + Termux:Boot from F-Droid
2. Disable battery optimization for both apps
3. Run setup script: `./scripts/setup_fleet_node.sh android-j7-02`
4. Reboot phone

After boot (and unlock), SSH + worker daemon auto-start in ~90 seconds.

## Quick Start - Debloating (Optional)

**Prerequisites:**
- Android SDK Platform Tools (ADB)
- Samsung Galaxy J7 with USB debugging enabled
- USB cable

**Run Debloat:**
```bash
./scripts/aggressive_debloat.sh
```

This removes 70+ bloatware packages while preserving camera, phone, and core Android functionality.

## What Gets Removed

- All Verizon carrier apps (9 packages)
- Samsung account/cloud services (35+ packages)
- Google bloatware (11 packages, keeps Play Store)
- Print services, VPN, accessibility features
- Samsung themes and customization apps

## What Stays

- Camera and Gallery
- Phone and SMS
- WiFi, Bluetooth, Settings
- Google Play Store and Services
- Core Android system

## Results

| Metric | Before | After |
|--------|--------|-------|
| Total Packages | 235 | 165 |
| Bloatware Removed | 0 | 70 (30%) |
| Verizon Apps | 9 | 0 |

## Available Scripts

### Debloating
- `aggressive_debloat.sh` - Main debloat script (removes 70 packages)
- `disable_bloatware.sh` - Conservative removal (Verizon only)
- `restore_all.sh` - Emergency restore

### Storage Cleanup
- `weekly_cleanup.sh` - Clear caches, temp files (run weekly)
- `monthly_cleanup.sh` - Deep clean including logs (run monthly)
- `quarterly_cleanup.sh` - Full cleanup with download review (run quarterly)
- `clear_all_caches.sh` - Clear all app caches

### System Setup
- `check_prerequisites.sh` - Verify ADB and device connection
- `setup_termux_sdcard.sh` - Configure Termux storage
- `install_debian_with_ssh.sh` - Install Debian in Termux
- `setup_ssh_autostart.sh` - Auto-start SSH on boot

## Emergency Restore

If something breaks:
```bash
# Restore all packages
./scripts/restore_all.sh

# Or manually re-enable a package
adb shell pm enable PACKAGE_NAME
```

## Storage Management

After debloating, maintain your device:

```bash
# Weekly (2 min)
./scripts/weekly_cleanup.sh

# Monthly (5 min)
./scripts/monthly_cleanup.sh

# Quarterly (10 min)
./scripts/quarterly_cleanup.sh
```

## Advanced: Termux Setup

Install Termux from F-Droid, then:

```bash
# Configure storage access
./scripts/setup_termux_sdcard.sh

# Install Debian environment
./scripts/install_debian_with_ssh.sh

# Enable SSH on boot
./scripts/setup_ssh_autostart.sh
```

## Troubleshooting

**Camera broken after debloat?**
```bash
./scripts/restore_all.sh
```

**Can't connect to device?**
```bash
./scripts/check_prerequisites.sh
```

**Want to see what's disabled?**
```bash
adb shell pm list packages -d
```

## Safety

- All scripts check for package existence before operations
- Non-destructive: packages are disabled, not deleted
- Full restore capability included
- Tested on Samsung Galaxy J7 (Verizon model)

## License

GPL v3.0 - See LICENSE file

## Fleet Worker Features

**What Auto-Starts After Boot:**
- ✅ SSH server (port 8022) - passwordless access from laptop-01
- ✅ Worker daemon (port 9003) - HTTP API for fleet control
- ✅ Fleet registration - heartbeat to aio-01:8004

**Worker API:**
```bash
# Health check
curl http://192.168.1.248:9003/health

# Execute command
curl -X POST http://192.168.1.248:9003/execute \
  -H "Content-Type: application/json" \
  -d '{"command": "python3", "args": ["-c", "print(\"Hello!\")"]}'
```

**SSH Access:**
```bash
ssh -p 8022 192.168.1.248
```

## Architecture

```
Phone Boot
    ↓
Termux:Boot triggered (after unlock)
    ↓
~/.termux/boot/start-worker
    ├─ Start SSH server (port 8022)
    ├─ Wait for network (ping aio-01)
    ├─ 30s stabilization delay
    ├─ Start worker-daemon.py (port 9003)
    └─ Start worker-register.sh (heartbeat to aio-01:8004)
```

Total boot time: ~90 seconds from power-on to fully operational.

## Current Status

**Fleet Workers:**
- android-j7-01: ✅ Production ready (SSH + daemon auto-start working)
- android-j7-02: Pending setup

**Debloating:**
See `currently_disabled.txt` for list of 70 disabled packages and `docs/DEBLOAT_SUMMARY.txt` for detailed results.
