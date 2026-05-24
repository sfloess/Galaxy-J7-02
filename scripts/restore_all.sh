#!/bin/bash
# Re-enable all disabled packages to restore camera functionality

# Check ADB connection first
if ! command -v adb &> /dev/null; then
    echo "❌ ERROR: ADB not found in PATH"
    exit 1
fi

if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

echo "🔄 Re-enabling all previously disabled packages..."
echo ""

# Helper function to safely enable packages
enable_package() {
    local pkg=$1
    # Check if package exists and is disabled
    if adb shell pm list packages -d 2>/dev/null | grep -q "^package:${pkg}$"; then
        adb shell pm enable "$pkg" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  ✓ Enabled: $pkg"
        else
            echo "  ⚠ Failed to enable: $pkg"
        fi
    else
        # Package not disabled or doesn't exist - skip silently
        echo "  - Skipped: $pkg (not disabled)"
    fi
}

enable_package com.monotype.android.font.rosemary
enable_package com.vzw.apnlib
enable_package com.google.android.googlequicksearchbox
enable_package com.verizon.mips.services
enable_package com.qualcomm.ltebc_vzw
enable_package com.sec.android.easyonehand
enable_package com.verizon.obdm_permissions
enable_package com.cequint.ecid
enable_package com.sec.android.widgetapp.easymodecontactswidget
enable_package com.vcast.mediamanager
enable_package com.sec.android.app.soundalive
enable_package com.samsung.android.sdk.professionalaudio.utility.jammonitor
enable_package com.sec.android.app.clockpackage
enable_package com.google.android.syncadapters.contacts
enable_package com.android.chrome
enable_package com.google.android.partnersetup
enable_package com.customermobile.preload.vzw
enable_package com.google.android.feedback
enable_package com.google.android.apps.photos
enable_package com.google.android.syncadapters.calendar
enable_package com.hancom.office.viewer
enable_package com.monotype.android.font.chococooky
enable_package com.sec.android.app.shealth
enable_package com.google.android.backuptransport
enable_package com.LogiaGroup.LogiaDeck
enable_package com.sec.android.emergencylauncher
enable_package com.verizon.obdm
enable_package com.samsung.android.dlp.service
enable_package com.samsung.android.sdk.professionalaudio.app.audioconnectionservice
enable_package com.enhance.gameservice
enable_package com.monotype.android.font.cooljazz
enable_package qualcomm.com.vzw_msdc_api
enable_package com.sec.android.app.magnifier
enable_package com.samsung.upsmtheme
enable_package com.verizon.llkagent

echo ""
echo "✅ Package restore complete"
echo ""
echo "Testing camera..."
adb shell pm clear com.sec.android.app.camera
adb shell am start -n com.sec.android.app.camera/.Camera
