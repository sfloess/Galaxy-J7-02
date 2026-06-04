# Internal Storage Analysis
**Date**: 2026-05-26  
**Device**: Samsung Galaxy J7 (SM-J727V)  
**Issue**: Internal storage at 90% capacity

## Current Storage Status

```
Total Internal Storage: 10GB
Used: 9.1GB (90%)
Free: 1.1GB (10%)
```

### Storage Breakdown

| Category | Size | Percentage |
|----------|------|------------|
| **App APKs** | 5.8GB | 58% |
| **App Data** | 2.9GB | 29% |
| **App Cache** | 35MB | <1% |
| **System** | 4.6GB | Read-only |

## Problem Analysis

### 1. Google Play Services - **MAJOR CULPRIT** 🔴
- **Data size**: ~2.1GB (!!!)
- **Impact**: Consuming 21% of total internal storage
- **Reason**: Accumulated data, sync, location history, Play Services cache

### 2. App APKs - 5.8GB
- **20 user-installed apps**
- **200+ system/bloatware packages** (many disabled but not uninstalled)
- System packages still consume space even when disabled

### 3. Disabled But Not Removed
- **87 packages disabled** but still installed
- Each disabled package still takes up space for APK files
- System bloat is in /system (read-only) but some are in /data (removable)

## Solutions Implemented

### ✅ What We've Done So Far
1. Uninstalled Google Search (~120MB saved)
2. Uninstalled Samsung Mobile Service (~30MB saved)
3. Cleared app caches (already minimal)

### 🔧 Immediate Actions Needed

#### Priority 1: Clear Google Play Services Data (Save ~1.5-2GB!)

**WARNING**: This will:
- Sign you out of Google accounts temporarily
- Clear Play Store download cache
- Reset app preferences
- Require re-login to Google

**How to do it**:
```bash
# Option A: Via ADB (safer, preserves settings)
adb shell pm clear com.google.android.gms

# Option B: On phone
Settings → Apps → Google Play Services → Storage → Clear Data
```

**Expected savings**: 1.5-2GB

#### Priority 2: Uninstall More User Apps

Review and uninstall apps you don't need:

**Current user apps (20 installed)**:
1. de.blinkt.openvpn - OpenVPN
2. com.teslacoilsw.launcher - Nova Launcher
3. com.alphainventor.filemanager - File Manager
4. com.openai.chatgpt - ChatGPT
5. com.termux.boot - Termux Boot
6. org.zwanoo.android.speedtest - Speedtest
7. com.ng_labs.colorwallpaper - Wallpaper app
8. org.kde.kdeconnect_tp - KDE Connect
9. com.developerinabox.Agent - Agent app
10. com.catinthebox.dnsspeedtest - DNS Speed Test
11. org.fdroid.fdroid - F-Droid
12. com.mcu.reolink - Reolink camera
13. com.dev47apps.obsdroidcam - OBS Camera
14. org.mozilla.firefox - Firefox
15. com.termux - Termux (KEEP!)
16. org.fedorahosted.freeotp - FreeOTP
17. com.a0soft.gphone.acc.free - Accelerometer app
18. com.authy.authy - Authy
19. flar2.devcheck - DevCheck
20. com.google.android.apps.adm - Find My Device

**Recommendations**:
- **Keep**: Termux, FreeOTP, Authy (essential)
- **Consider removing**: 
  - Wallpaper apps (use default)
  - Duplicate speed test apps
  - Reolink if not using camera
  - OBS camera if not needed

**Potential savings**: 200-500MB depending on which apps removed

#### Priority 3: Move Data to SD Card

Your SD card has **80GB free** - use it!

**What to move**:
1. **Photos/Videos**: Move from internal to SD card
2. **Downloads**: Already on SD card (good!)
3. **App data**: Some apps can store data on SD card

**How to move photos**:
```bash
# Via ADB
adb shell "mv /sdcard/DCIM/* /sdcard/Android/media/DCIM/"

# Or on phone
Use file manager to move DCIM, Pictures folders to SD card
```

**Expected savings**: Varies (100MB-2GB depending on media)

#### Priority 4: Uninstall vs Disable

Create a script to fully **uninstall** all disabled packages:

```bash
# Run the cleanup script (already created)
./scripts/cleanup_internal_storage.sh
```

**Expected savings**: 50-200MB

## Long-Term Recommendations

### 1. Periodic Maintenance Schedule

**Weekly**:
- Clear browser cache (Chrome, Firefox)
- Delete old downloads
- Clear messaging app media

**Monthly**:
- Review and uninstall unused apps
- Clear Google Play Services cache (Settings → Apps → GMS → Storage → Clear Cache)
- Move new photos to SD card

**Quarterly**:
- Clear Google Play Services **data** (requires re-login)
- Review Termux package cache: `pkg clean`

### 2. Prevent Future Bloat

**Configure apps to use SD card**:
- Camera: Save photos to SD card
  - Camera app → Settings → Storage location → SD card
- Downloads: Already configured to SD card
- Termux: Already using SD card symlinks

**Disable auto-updates**:
- Play Store → Settings → Auto-update apps → Don't auto-update
- Only update apps you actively use

### 3. Use Lightweight Alternatives

Replace heavy apps with lighter alternatives:

| Heavy App | Lightweight Alternative | Savings |
|-----------|-------------------------|---------|
| Chrome | Via browser (built-in) | N/A (system) |
| Firefox | Fennec F-Droid | ~50MB |
| Nova Launcher | Simple Launcher | ~150MB |
| Multiple speed test apps | Keep just one | ~50MB |

### 4. Monitor Storage

**Create monitoring script**:
```bash
#!/bin/bash
# Quick storage check
adb shell df -h | grep "/data" | head -1
adb shell dumpsys diskstats | grep "Data-Free"
```

**Set threshold alert**: When storage drops below 15% (1.5GB), take action

## Detailed Action Plan

### Step 1: Clear Google Play Services Data ⚠️
```bash
# Backup first (optional)
adb backup com.google.android.gms

# Clear data
adb shell pm clear com.google.android.gms

# Savings: ~1.5-2GB
```

### Step 2: Uninstall Unused Apps
```bash
# Example: Remove wallpaper app
adb shell pm uninstall --user 0 com.ng_labs.colorwallpaper

# Example: Remove duplicate speed test
adb shell pm uninstall --user 0 com.catinthebox.dnsspeedtest

# Savings: ~100-300MB
```

### Step 3: Move Media to SD Card
```bash
# Check current media size
adb shell du -sh /sdcard/DCIM /sdcard/Pictures /sdcard/Movies

# Move to SD card location
# (Do this manually on phone using file manager)

# Savings: Variable
```

### Step 4: Run Full Cleanup
```bash
# Our cleanup script
./scripts/cleanup_internal_storage.sh

# Savings: ~50-100MB
```

### Step 5: Configure Camera for SD Card
```
On phone:
Camera app → Settings → Storage → SD card
```

## Expected Total Savings

| Action | Savings | Difficulty |
|--------|---------|-----------|
| Clear Play Services data | 1.5-2GB | Easy (requires re-login) |
| Uninstall 3-5 unused apps | 200-500MB | Easy |
| Move photos to SD card | 100MB-2GB | Easy |
| Uninstall disabled bloat | 50-200MB | Easy (script) |
| **TOTAL POTENTIAL** | **~2-4.7GB** | **1-2 hours** |

## Final Target

**Current**: 1.1GB free (10%)  
**After cleanup**: 3-5GB free (30-50%)  
**Comfortable operation**: Maintain >2GB free (20%)

## Automation Scripts

### Daily Quick Check
```bash
#!/bin/bash
# Save as: check_storage.sh
adb shell df -h | grep "/data" | awk '{print "Storage: "$3" used of "$2" ("$5" full)"}'
```

### Weekly Cleanup
```bash
#!/bin/bash
# Save as: weekly_cleanup.sh
echo "Clearing browser cache..."
adb shell pm clear com.android.chrome --cache-only
adb shell pm clear org.mozilla.firefox --cache-only

echo "Clearing download cache..."
adb shell rm -rf /sdcard/Download/*.tmp

echo "Storage after cleanup:"
adb shell df -h | grep "/data"
```

## Notes

- Google Play Services data accumulates quickly - plan to clear every 2-3 months
- Disabled system packages in /system partition can't be removed without root
- Always test camera after any cleanup operations
- SD card is your friend - use it liberally
- Keep at least 1.5-2GB free for optimal performance

## References

- Original debloat: 92 packages disabled
- Current status: 144 packages enabled (down from 236)
- User apps: 20 installed
- SD card space: 80GB available

---

**Next steps**: 
1. Clear Google Play Services data (biggest impact)
2. Uninstall 3-5 unused apps
3. Set up weekly cleanup cron job
