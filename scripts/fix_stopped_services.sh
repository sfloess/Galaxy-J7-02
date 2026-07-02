#!/bin/bash
# Fix "X has stopped" errors after aggressive cleanup
# This reinstalls critical system packages that were uninstalled

set -euo pipefail

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   FIX 'HAS STOPPED' ERRORS                                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "This script reinstalls system packages that should be DISABLED,"
echo "not UNINSTALLED. These packages are needed by other services."
echo ""

# Critical system packages that should exist (even if disabled)
declare -A critical_packages=(
    # Calendar/Contacts
    ["com.google.android.syncadapters.calendar"]="Google Calendar Sync"
    ["com.google.android.syncadapters.contacts"]="Google Contacts Sync"
    ["com.android.providers.contacts"]="Contacts Provider"

    # ANT Radio (fitness devices)
    ["com.dsi.ant.server"]="ANT Radio Server"
    ["com.dsi.ant.service.socket"]="ANT Service Socket"
    ["com.dsi.ant.sample.acquirechannels"]="ANT Sample App"

    # Samsung Core Services
    ["com.samsung.unifiedsettingservice"]="Samsung Unified Settings"

    # Other potentially needed
    ["com.android.printspooler"]="Print Spooler"
    ["com.google.android.tts"]="Google Text-to-Speech"
)

echo "Checking and reinstalling missing packages..."
echo ""

reinstalled=0
already_installed=0
failed=0

for pkg in "${!critical_packages[@]}"; do
    desc="${critical_packages[$pkg]}"

    # Check if package exists
    if adb shell pm list packages | grep -q "^package:$pkg$"; then
        echo "✓ $desc ($pkg) - Already installed"
        ((already_installed++))
    else
        echo -n "⚠ $desc ($pkg) - Reinstalling... "
        if adb shell cmd package install-existing "$pkg" 2>&1 | grep -q "installed"; then
            echo "✓"
            ((reinstalled++))
        else
            echo "✗ (not available on this device)"
            ((failed++))
        fi
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results:"
echo "  ✓ Already installed: $already_installed"
echo "  ✓ Reinstalled: $reinstalled"
echo "  ✗ Not available: $failed"
echo ""

if [ $reinstalled -gt 0 ]; then
    echo "Now disabling reinstalled packages (keep installed but inactive)..."
    echo ""

    for pkg in "${!critical_packages[@]}"; do
        if adb shell pm list packages | grep -q "^package:$pkg$"; then
            # Check if it's enabled
            if ! adb shell pm list packages -d | grep -q "$pkg"; then
                desc="${critical_packages[$pkg]}"
                echo -n "• Disabling $desc... "
                adb shell pm disable-user --user 0 "$pkg" 2>&1 | grep -q "disabled" && echo "✓" || echo "⊘"
            fi
        fi
    done

    echo ""
    echo "Clearing system caches..."
    adb shell pm trim-caches 999999999999 2>/dev/null
    echo "✓ Caches cleared"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ COMPLETE!"
echo ""

if [ $reinstalled -gt 0 ]; then
    echo "✨ Fixed $reinstalled 'has stopped' errors"
    echo ""
    echo "💡 The reinstalled packages are now DISABLED (not uninstalled)"
    echo "   They won't run, but won't cause crashes either."
else
    echo "✨ All critical packages already present"
    echo "   No 'has stopped' errors should occur."
fi

echo ""
echo "📝 If you still see errors, note the package name and run:"
echo "   adb shell cmd package install-existing PACKAGE_NAME"
echo "   adb shell pm disable-user --user 0 PACKAGE_NAME"
echo ""
