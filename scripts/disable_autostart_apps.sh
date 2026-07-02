#!/bin/bash
# Disable auto-start for apps that don't need to run at boot
# This prevents apps from starting automatically but they still work when launched manually

set -euo pipefail

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

echo "🚫 Disabling Auto-Start for Selected Apps"
echo "=========================================="
echo ""
echo "These apps will NOT start automatically at boot,"
echo "but will work normally when you launch them manually."
echo ""

# Apps that don't need auto-start
declare -a packages=(
    "org.kde.kdeconnect_tp"          # KDE Connect
    "com.authy.authy"                # Authy
    "com.alphainventor.filemanager"  # File Manager
    "flar2.devcheck"                 # DevCheck
    "de.blinkt.openvpn"              # OpenVPN
    "com.dev47apps.obsdroidcam"      # DroidCam
    "com.mcu.reolink"                # Reolink
    "org.fdroid.fdroid"              # F-Droid
    "org.mozilla.firefox"            # Firefox
    "com.anthropic.claude"           # Claude
    "com.openai.chatgpt"             # ChatGPT
    "com.scannerreader.qrcode.creatorfree"  # QR Scanner
    "com.vitastudio.mahjong"         # Mahjong
)

echo "📋 Apps to restrict:"
count=0
for pkg in "${packages[@]}"; do
    ((count++))
    echo "  $count. $pkg"
done

echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo ""
echo "🔧 Applying restrictions..."
echo ""

success=0
for pkg in "${packages[@]}"; do
    echo "• $pkg"

    # Method 1: Set app to standby (less aggressive)
    if adb shell am set-inactive "$pkg" true 2>&1 | grep -q "^$"; then
        echo "  ✓ Set to standby mode"
    fi

    # Method 2: Block background execution (more aggressive)
    if adb shell cmd appops set "$pkg" RUN_IN_BACKGROUND deny 2>&1 | grep -q "^$"; then
        echo "  ✓ Background execution blocked"
        ((success++))
    else
        echo "  ⚠ Could not block background (may not be installed)"
    fi

    echo ""
done

echo "=========================================="
echo "✅ Auto-start disabled for $success apps!"
echo ""
echo "📝 What was done:"
echo "  - Apps set to 'standby' mode (less background activity)"
echo "  - Background execution blocked (no auto-start at boot)"
echo ""
echo "🎯 Result:"
echo "  - Apps won't start automatically when you boot your phone"
echo "  - Apps still work perfectly when you open them manually"
echo "  - Battery life should improve slightly"
echo ""
echo "♻️  To undo (re-enable auto-start for an app):"
echo "  adb shell cmd appops set PACKAGE_NAME RUN_IN_BACKGROUND allow"
echo "  adb shell am set-inactive PACKAGE_NAME false"
echo ""
