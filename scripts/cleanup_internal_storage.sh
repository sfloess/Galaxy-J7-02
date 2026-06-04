#!/bin/bash
# Cleanup Internal Storage - Uninstall disabled bloatware to free space
# This removes disabled packages that are still consuming internal storage

echo "🧹 Internal Storage Cleanup"
echo "=========================================="
echo ""

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

# Show current storage
echo "📊 Current Storage Usage:"
adb shell df -h | grep "/data" | head -1
echo ""

echo "This script will UNINSTALL (not just disable) the following:"
echo "  - Disabled Samsung bloatware"
echo "  - Disabled Verizon apps"
echo "  - Disabled Google apps"
echo ""
echo "⚠️  These can be restored via factory reset if needed"
echo ""

read -p "Continue with cleanup? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo ""
echo "🗑️  Uninstalling disabled bloatware..."
echo ""

# Counter for tracking
removed=0
failed=0

# Function to uninstall disabled packages
uninstall_if_disabled() {
    local pkg=$1
    local name=$2

    # Check if package is disabled
    if adb shell pm list packages -d 2>/dev/null | grep -q "^package:${pkg}$"; then
        echo -n "  Removing $name... "
        if adb shell pm uninstall --user 0 "$pkg" 2>/dev/null | grep -q "Success"; then
            echo "✓"
            ((removed++))
        else
            echo "✗ (may be system package)"
            ((failed++))
        fi
    else
        echo "  Skipped $name (not disabled or not installed)"
    fi
}

echo "Phase 1: Samsung Bloatware"
echo "----------------------------"
uninstall_if_disabled "com.samsung.android.mobileservice" "Samsung Experience Service"
uninstall_if_disabled "com.osp.app.signin" "Samsung Account"
uninstall_if_disabled "com.samsung.android.smartmirroring" "Smart View"
uninstall_if_disabled "com.samsung.android.app.assistantmenu" "Assistant Menu"
uninstall_if_disabled "com.samsung.android.da.daagent" "Dual Audio"
uninstall_if_disabled "com.samsung.advp.imssettings" "Advanced Calling"
uninstall_if_disabled "com.samsung.android.location" "Samsung Location"
uninstall_if_disabled "com.samsung.clipboardsaveservice" "Clipboard Save"
uninstall_if_disabled "com.samsung.android.clipboarduiservice" "Clipboard UI"
uninstall_if_disabled "com.samsung.android.securitylogagent" "Security Log"
uninstall_if_disabled "com.samsung.carrier.logcollector" "Log Collector"
uninstall_if_disabled "com.samsung.faceservice" "Face Service"
uninstall_if_disabled "com.samsung.android.easysetup" "Easy Setup"
uninstall_if_disabled "com.samsung.huxextension" "HUX Extension"
uninstall_if_disabled "com.samsung.android.timezone.autoupdate_O" "Timezone Auto Update"

echo ""
echo "Phase 2: Verizon Bloatware"
echo "----------------------------"
uninstall_if_disabled "com.verizon.mips.services" "Verizon Services"
uninstall_if_disabled "com.verizon.obdm_permissions" "Verizon OBDM"

echo ""
echo "Phase 3: Google Bloatware"
echo "----------------------------"
uninstall_if_disabled "com.google.android.googlequicksearchbox" "Google Search"
uninstall_if_disabled "com.google.android.marvin.talkback" "TalkBack"
uninstall_if_disabled "com.google.android.setupwizard" "Setup Wizard"
uninstall_if_disabled "com.google.android.syncadapters.contacts" "Google Contact Sync"
uninstall_if_disabled "com.google.android.syncadapters.calendar" "Google Calendar Sync"
uninstall_if_disabled "com.google.android.tts" "Google Text-to-Speech"
uninstall_if_disabled "com.google.android.printservice.recommendation" "Print Service"

echo ""
echo "Phase 4: Other Bloatware"
echo "----------------------------"
uninstall_if_disabled "com.android.printspooler" "Print Spooler"
uninstall_if_disabled "com.android.wallpapercropper" "Wallpaper Cropper"
uninstall_if_disabled "com.sec.android.wallpapercropper2" "Wallpaper Cropper 2"
uninstall_if_disabled "com.android.documentsui" "Documents UI"
uninstall_if_disabled "com.android.egg" "Easter Egg"
uninstall_if_disabled "com.dsi.ant.service.socket" "ANT Radio Service"
uninstall_if_disabled "com.dsi.ant.sample.acquirechannels" "ANT Sample"
uninstall_if_disabled "com.sec.android.app.soundalive" "Sound Alive"

echo ""
echo "=========================================="
echo "✅ Cleanup Complete!"
echo ""
echo "📊 Results:"
echo "  ✓ Removed: $removed packages"
echo "  ✗ Failed: $failed packages"
echo ""

echo "📊 New Storage Usage:"
adb shell df -h | grep "/data" | head -1
echo ""

echo "💡 Additional Cleanup Options:"
echo "  1. Clear app caches: Settings → Storage → Cached data"
echo "  2. Delete old downloads: /sdcard/Download/"
echo "  3. Remove unused user apps"
echo "  4. Move photos/videos to SD card"
echo ""
