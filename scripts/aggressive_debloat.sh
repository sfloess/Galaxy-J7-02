#!/bin/bash
# AGGRESSIVE Debloat - Turn Samsung J7 into a mini computer
# Removes all non-essential bloatware while keeping camera and core Android

# Check ADB connection first
if ! command -v adb &> /dev/null; then
    echo "❌ ERROR: ADB not found in PATH"
    echo "   Install Android SDK Platform Tools"
    exit 1
fi

if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    echo "   1. Enable USB Debugging on your phone"
    echo "   2. Connect via USB"
    echo "   3. Accept authorization prompt on phone"
    exit 1
fi

echo "🚀 AGGRESSIVE DEBLOAT MODE"
echo ""
echo "This will transform your phone into a minimal Android computer."
echo ""
echo "WILL BE DISABLED:"
echo "  - All Samsung account/cloud services"
echo "  - Samsung themes and customization"
echo "  - Most Google apps (keeping Play Store/Services)"
echo "  - Accessibility features"
echo "  - Samsung Smart features"
echo "  - Print services"
echo "  - VPN and enterprise features"
echo ""
echo "WILL BE KEPT:"
echo "  - Camera and Gallery"
echo "  - Phone and SMS"
echo "  - Core Android system"
echo "  - Google Play Store/Services"
echo "  - Settings and Launcher"
echo ""

read -p "Continue with aggressive debloat? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Helper function to safely disable packages
disable_package() {
    local pkg=$1
    # Check if package exists first
    if adb shell pm list packages 2>/dev/null | grep -q "^package:${pkg}$"; then
        adb shell pm disable-user --user 0 "$pkg" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  ✓ Disabled: $pkg"
        else
            echo "  ⚠ Failed: $pkg (may require special permissions)"
        fi
    else
        echo "  - Skipped: $pkg (not installed on this device)"
    fi
}

echo ""
echo "🗑️  Phase 1: Samsung Account & Cloud Services"

disable_package com.samsung.android.mobileservice
disable_package com.osp.app.signin
disable_package com.samsung.android.scloud
disable_package com.samsung.android.samsungpass

echo "🗑️  Phase 2: Samsung Smart Features"

disable_package com.samsung.android.smartmirroring
disable_package com.samsung.advancedcalling
disable_package com.samsung.advp.imssettings
disable_package com.samsung.android.da.daagent
disable_package com.samsung.SMT

echo "🗑️  Phase 3: Samsung UI & Customization"

disable_package com.samsung.android.themestore
disable_package com.sec.android.app.personalization
disable_package com.android.wallpapercropper
disable_package com.sec.android.wallpapercropper2
disable_package com.android.wallpaper.livepicker
disable_package com.android.dreams.basic
disable_package com.android.dreams.phototable

echo "🗑️  Phase 4: Accessibility Features (if you don't use them)"

disable_package com.samsung.android.app.assistantmenu
disable_package com.google.android.marvin.talkback
disable_package com.samsung.android.app.accesscontrol
disable_package com.sec.hearingadjust

echo "🗑️  Phase 5: Google Apps (keeping essentials)"

disable_package com.google.android.gm  # Gmail
disable_package com.google.android.tts  # Text-to-speech
disable_package com.google.android.apps.photos  # Google Photos
disable_package com.google.android.googlequicksearchbox  # Google search
disable_package com.google.android.feedback
disable_package com.google.android.printservice.recommendation
disable_package com.google.android.setupwizard
disable_package com.google.android.partnersetup
disable_package com.google.android.syncadapters.contacts
disable_package com.google.android.syncadapters.calendar
disable_package com.google.android.backuptransport

echo "🗑️  Phase 6: Print & Document Services"

disable_package com.android.printspooler
disable_package com.android.bips
disable_package com.android.documentsui

echo "🗑️  Phase 7: Samsung System Services (non-critical)"

disable_package com.samsung.android.app.soundpicker
disable_package com.sec.android.app.soundalive
disable_package com.samsung.android.location  # Warning: may affect GPS
disable_package com.samsung.networkui
disable_package com.samsung.android.timezone.autoupdate_O
disable_package com.samsung.unifiedsettingservice

echo "🗑️  Phase 8: VPN & Enterprise"

disable_package com.android.vpndialogs
disable_package com.knox.vpn.proxyhandler
disable_package com.sec.enterprise.mdm.vpn
disable_package com.android.managedprovisioning

echo "🗑️  Phase 9: Miscellaneous Bloat"

disable_package com.android.egg  # Easter egg
disable_package com.sec.android.easyMover.Agent
disable_package com.sec.android.app.setupwizard
disable_package com.samsung.huxextension
disable_package com.sec.android.app.DataCreate
disable_package com.sec.android.emergencymode.service
disable_package com.sec.android.provider.emergencymode

echo "🗑️  Phase 10: Photo/Image Extras"

disable_package com.sec.android.mimage.photoretouching

echo ""
echo "✅ AGGRESSIVE DEBLOAT COMPLETE!"
echo ""
echo "Testing camera..."
adb shell am start -n com.sec.android.app.camera/.Camera

sleep 3

echo ""
echo "📊 Statistics:"
echo -n "Total disabled packages: "
adb shell pm list packages -d | wc -l
echo -n "Total enabled packages: "
adb shell pm list packages -e | wc -l
echo ""
echo "⚠️  CRITICAL: TEST EVERYTHING NOW!"
echo "   - Camera (photo/video)"
echo "   - Phone calls"
echo "   - Text messages"
echo "   - WiFi/Data"
echo "   - Play Store"
echo ""
echo "If anything critical is broken, re-enable with:"
echo "  adb shell pm enable PACKAGE_NAME"
