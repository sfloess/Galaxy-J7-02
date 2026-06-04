# User-Installed Apps Review
**Date**: 2026-05-26  
**Total User Apps**: 20

## App List with Recommendations

| # | App Name | Package | Version | Recommendation | Reason |
|---|----------|---------|---------|----------------|--------|
| 1 | OpenVPN | de.blinkt.openvpn | 0.7.64 | **KEEP** | VPN connectivity |
| 2 | Nova Launcher | com.teslacoilsw.launcher | 8.7.8 | Consider | Heavy (~180MB), could use stock launcher |
| 3 | File Manager | com.alphainventor.filemanager | 3.7.2 | Consider | ~40MB, redundant if using Termux |
| 4 | ChatGPT | com.openai.chatgpt | 1.2026.125 | **KEEP/REVIEW** | Useful but ~125MB |
| 5 | Termux:Boot | com.termux.boot | 0.8.1 | **KEEP** | Essential for auto-start |
| 6 | Speedtest (Ookla) | org.zwanoo.android.speedtest | 7.0.3 | **REMOVE** | Duplicate speed test app |
| 7 | Color Wallpaper | com.ng_labs.colorwallpaper | 3.0.0 | **REMOVE** | Unnecessary, use default |
| 8 | KDE Connect | org.kde.kdeconnect_tp | 1.35.6 | **KEEP/REVIEW** | Phone-PC sync, useful if you use it |
| 9 | Agent | com.developerinabox.Agent | 2.4 | **REVIEW** | Unknown purpose |
| 10 | DNS Speed Test | com.catinthebox.dnsspeedtest | 5.6.4 | **REMOVE** | Redundant with other speed test |
| 11 | F-Droid | org.fdroid.fdroid | 1.23.2 | **KEEP** | Essential app store |
| 12 | Reolink | com.mcu.reolink | 4.60.0.6 | **REVIEW** | Keep only if using Reolink cameras |
| 13 | DroidCam OBS | com.dev47apps.obsdroidcam | 9.0 | **REVIEW** | Keep only if using as webcam |
| 14 | Firefox | org.mozilla.firefox | 151.0 | **KEEP/REVIEW** | ~300MB, redundant with Chrome |
| 15 | Termux | com.termux | 0.118.0 | **KEEP** | Essential! |
| 16 | FreeOTP | org.fedorahosted.freeotp | 2.0.6 | **KEEP** | 2FA authentication |
| 17 | Accelerometer | com.a0soft.gphone.acc.free | 5.15 | **REMOVE** | Niche use, likely unused |
| 18 | Authy | com.authy.authy | 27.5.2 | **KEEP** | 2FA authentication |
| 19 | DevCheck | flar2.devcheck | 6.40 | **KEEP/REVIEW** | Hardware info, useful for debugging |
| 20 | Find My Device | com.google.android.apps.adm | 3.1.608-5 | **KEEP** | Security/recovery |

## Summary by Category

### 🟢 Essential (Must Keep) - 6 apps
1. Termux - Core functionality
2. Termux:Boot - Auto-start services
3. F-Droid - App store
4. FreeOTP - 2FA security
5. Authy - 2FA security
6. OpenVPN - VPN access

### 🟡 Useful (Review Based on Usage) - 8 apps
1. Nova Launcher - Heavy but feature-rich (~180MB)
2. ChatGPT - AI assistant (~125MB)
3. KDE Connect - PC integration
4. Reolink - Only if you have Reolink cameras
5. DroidCam OBS - Only if using phone as webcam
6. Firefox - Redundant with Chrome (~300MB)
7. DevCheck - Hardware diagnostics
8. Find My Device - Security feature

### 🔴 Recommended for Removal - 6 apps
1. **Speedtest (Ookla)** - Duplicate functionality
2. **Color Wallpaper** - Unnecessary bloat
3. **DNS Speed Test** - Duplicate functionality
4. **Agent** - Unknown/unused
5. **File Manager** - Redundant with Termux
6. **Accelerometer** - Niche/unused

## Storage Impact

### If Removing All Recommended Apps:
```bash
# Speedtest
adb shell pm uninstall --user 0 org.zwanoo.android.speedtest

# Wallpaper
adb shell pm uninstall --user 0 com.ng_labs.colorwallpaper

# DNS Speed Test
adb shell pm uninstall --user 0 com.catinthebox.dnsspeedtest

# Agent
adb shell pm uninstall --user 0 com.developerinabox.Agent

# File Manager (optional)
adb shell pm uninstall --user 0 com.alphainventor.filemanager

# Accelerometer
adb shell pm uninstall --user 0 com.a0soft.gphone.acc.free
```

**Expected savings**: ~200-300MB

### Aggressive Option (Review First):
If you also remove:
- Nova Launcher (use stock) - ~180MB
- Firefox (use Chrome) - ~300MB
- ChatGPT (if not using) - ~125MB

**Additional savings**: ~600MB
**Total potential**: ~900MB

## Quick Command to Remove Safe Candidates

```bash
# Remove the 6 safe candidates
for pkg in org.zwanoo.android.speedtest com.ng_labs.colorwallpaper com.catinthebox.dnsspeedtest com.developerinabox.Agent com.a0soft.gphone.acc.free; do
    echo "Removing $pkg..."
    adb shell pm uninstall --user 0 "$pkg"
done
```

## Notes
- All apps can be reinstalled from F-Droid or Play Store
- Backup important data before uninstalling
- Test functionality after removals
- Some apps have data that should be backed up first
