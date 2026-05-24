# Fresh Galaxy J7 Setup Guide

This guide is for setting up a **brand new Galaxy J7** or a different J7 variant than the tested SM-J727V.

## What's New in v1.2.0

All scripts have been improved to work on fresh devices:

✅ **Automatic device detection**  
✅ **Graceful handling of missing packages**  
✅ **SD card auto-detection**  
✅ **Prerequisite validation**  
✅ **Better error messages**  

## Supported Devices

### Tested
- **SM-J727V** (Verizon) - Android 8.1.0

### Should Work (with minor differences)
- **SM-G610F** (J7 Prime) - Unlocked, international
- **SM-J730F** (J7 Pro) - Different Samsung apps
- **SM-J727T** (J7 2017) - T-Mobile variant
- **SM-S737TL** (J7 Sky Pro) - TracFone/prepaid
- **SM-J727P** (J7 Perx) - Sprint variant

## Step-by-Step Fresh Device Setup

### 1. Enable USB Debugging

On your phone:
1. Go to **Settings** → **About phone**
2. Tap **Build number** 7 times (enables Developer options)
3. Go back to **Settings** → **Developer options**
4. Enable **USB debugging**
5. Connect phone via USB
6. Accept the authorization prompt on phone

### 2. Clone Repository

```bash
git clone git@github.com:FlossWare/Samsung-Galaxy-J7.git
cd Samsung-Galaxy-J7
```

### 3. Run Prerequisite Check ⭐ NEW!

**ALWAYS run this first on a fresh device:**

```bash
bash scripts/check_prerequisites.sh
```

This will tell you:
- ✅ If ADB is connected
- ✅ Your device model and Android version
- ✅ If you're using a J7 variant
- ✅ If Termux is installed
- ✅ SD card status and free space
- ⚠️ Any warnings about compatibility

**Example output:**
```
╔══════════════════════════════════════════════════════════════╗
║   Prerequisite Checker for Galaxy J7 Setup                  ║
╚══════════════════════════════════════════════════════════════╝

[1/6] Checking ADB connection...
✅ ADB connected: SM-J727V

[2/6] Checking device model...
✅ Samsung Galaxy J7 detected: j7velte

[3/6] Checking Android version...
✅ Android version: 8.1.0

[4/6] Checking Termux installation...
⚠️  Termux not installed
    Install from: https://f-droid.org/packages/com.termux/

[5/6] Checking storage...
✅ Internal storage free: 3.2GB
✅ SD card found: 81.3GB free at /storage/2143-6716

[6/6] Checking USB debugging capabilities...
✅ Can query package list (USB debugging working)

╔══════════════════════════════════════════════════════════════╗
║   Summary                                                    ║
╚══════════════════════════════════════════════════════════════╝

⚠️  1 warning(s) - you can proceed but review warnings above
```

### 4. Debloat the Device

```bash
bash scripts/aggressive_debloat.sh
```

**What's improved:**
- ✅ Checks ADB connection before starting
- ✅ Skips packages that don't exist on your variant
- ✅ Shows which packages were disabled vs skipped
- ✅ Won't fail if carrier bloat differs

**Example output:**
```
🗑️  Phase 1: Samsung Account & Cloud Services
  ✓ Disabled: com.samsung.android.mobileservice
  ✓ Disabled: com.osp.app.signin
  - Skipped: com.samsung.android.samsungpass (not installed on this device)
```

**Testing camera:**
After debloating, the script will automatically test the camera. Make sure it works!

### 5. Install F-Droid and Termux

```bash
adb install apps/F-Droid.apk
adb install apps/termux.apk
```

Or download fresh:
- [F-Droid](https://f-droid.org/)
- [Termux](https://f-droid.org/packages/com.termux/)

### 6. Setup Termux Environment

```bash
adb push scripts/termux_setup.sh /sdcard/Download/
```

On your phone in Termux:
```bash
cp /sdcard/Download/termux_setup.sh ~
chmod +x ~/termux_setup.sh
~/termux_setup.sh
```

### 7. Configure SD Card ⭐ FIXED!

```bash
adb push scripts/setup_termux_sdcard.sh /sdcard/Download/
```

On your phone in Termux:
```bash
cp /sdcard/Download/setup_termux_sdcard.sh ~
bash ~/setup_termux_sdcard.sh
```

**What's improved:**
- ✅ Auto-detects SD card (external-1 or external-2)
- ✅ Creates actual symlinks (not directories)
- ✅ Verifies symlinks work
- ✅ Shows available space
- ❌ Fails with clear error if no SD card found

**Example output:**
```
[2/4] Creating directories on SD card...
✅ SD card detected: ~/storage/external-1

[4/4] Verifying setup...
✅ SD card symlinks created successfully

lrwxrwxrwx projects-sd -> /storage/2143-6716/Android/data/com.termux/files/projects
lrwxrwxrwx downloads-sd -> /storage/2143-6716/Android/data/com.termux/files/downloads

Available space on SD card:
  81.3G free of 119G
```

### 8. Install Debian with OpenSSH ⭐ IMPROVED!

```bash
adb push scripts/install_debian_with_ssh.sh /sdcard/Download/
```

On your phone in Termux:
```bash
cp /sdcard/Download/install_debian_with_ssh.sh ~
bash ~/install_debian_with_ssh.sh
```

**What's improved:**
- ✅ Auto-installs proot-distro if missing
- ✅ Checks SD card is configured first
- ✅ Warns if less than 1GB free
- ✅ Detects existing Debian installations
- ✅ Verifies each step succeeded
- ✅ Shows final installation size

**Example output:**
```
[0/5] Checking prerequisites...
✅ SD card has 81300MB available

[1/5] Installing Debian to SD card...
      This will download ~47MB and take 2-3 minutes
[...]

[5/5] Checking installation size...
✅ Debian installation size: 687M

╔══════════════════════════════════════════════════════════════╗
║   ✅ Installation Complete!                                  ║
╚══════════════════════════════════════════════════════════════╝
```

## Differences Between J7 Variants

### Package Names
Different carriers and regions have different bloatware:

| Carrier | Bloat Examples |
|---------|----------------|
| Verizon | com.verizon.mips.services, com.verizon.llkagent |
| T-Mobile | com.tmobile.pr.adapt, com.tmobile.services.nameid |
| AT&T | com.att.myWireless, com.att.tv |
| Sprint | com.sprint.care, com.sprint.ce.updater |

**The scripts handle this:** Missing packages are automatically skipped.

### Samsung Apps
Some Samsung apps vary by region:
- Samsung Pay (US/Korea only)
- Samsung Health (some regions)
- Bixby (newer models)

**The scripts handle this:** Only disables packages that exist.

### Android Version
Tested on **8.1.0**. May work on:
- ✅ Android 7.x (Nougat)
- ✅ Android 8.x (Oreo)
- ⚠️ Android 9.x (Pie) - some package names differ

## Troubleshooting Fresh Devices

### Camera Doesn't Work After Debloat

The scripts protect critical camera packages, but if it still breaks:

```bash
# Re-enable camera packages
adb shell pm enable com.samsung.cmh
adb shell pm enable com.sec.android.app.camera
adb shell pm enable com.samsung.android.providers.context
adb shell pm clear com.sec.android.app.camera
```

### Different Device Model Warning

If you see:
```
⚠️  Not a Galaxy J7 (found: j7popltevzw)
    Scripts may work but package names might differ
```

This is **OK**! The scripts will work but some packages might not exist on your variant. They'll be skipped automatically.

### No SD Card Detected

If you see:
```
❌ No SD card found!
   Make sure SD card is inserted and termux-setup-storage was run
```

1. Make sure SD card is physically inserted
2. In Termux, run: `termux-setup-storage`
3. Grant storage permission
4. Run the script again

### Package Already Disabled

Some packages might already be disabled. This is fine - the script will skip them.

## What to Expect on Different Variants

### Verizon J7 (SM-J727V) - Tested ✅
- 92 packages disabled
- All Verizon bloat removed
- Camera works perfectly
- 81GB SD card configured

### T-Mobile J7 (SM-J727T) - Should Work
- ~85-95 packages disabled (different carrier bloat)
- T-Mobile apps instead of Verizon
- Camera should work (same hardware)
- SD card configuration identical

### Unlocked J7 Prime (SM-G610F) - Should Work
- ~70-80 packages disabled (no carrier bloat)
- More Samsung apps, less carrier apps
- Camera should work
- SD card configuration identical

### International J7 - Should Work
- Package counts may vary
- Different region-specific apps
- Core functionality identical

## Success Checklist

After setup, verify:

- [ ] Camera works (take a photo)
- [ ] Gallery shows photos
- [ ] WiFi connects
- [ ] Play Store works
- [ ] Termux opens
- [ ] SD card accessible in Termux (`ls ~/projects-sd`)
- [ ] Debian can be entered (`proot-distro login debian`)
- [ ] SSH server installs in Debian
- [ ] (Optional) SSH auto-starts on boot

## Optional: Auto-Start SSH Server

To make your phone remotely accessible 24/7:

```bash
# In Termux
bash ~/setup_ssh_autostart.sh

# Then install Termux:Boot from F-Droid
# Open it once to grant permissions
```

See `docs/AUTO_START_SSH.md` for complete guide.

## Getting Help

If something doesn't work:

1. Check the output of `check_prerequisites.sh`
2. Review the specific error message
3. Check if your device is a known J7 variant
4. Report issues at: https://github.com/FlossWare/Samsung-Galaxy-J7/issues

Include:
- Your device model (`adb shell getprop ro.product.model`)
- Android version (`adb shell getprop ro.build.version.release`)
- Which script failed
- Complete error message

## Version History

- **v1.2.0** (2026-05-23) - ✅ Fresh device support added
- **v1.1.0** (2026-05-21) - Debian + OpenSSH added
- **v1.0.0** (2026-05-21) - Initial release

---

**Ready to start?** Run `bash scripts/check_prerequisites.sh` first!
