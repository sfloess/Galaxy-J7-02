#!/bin/bash
# Check prerequisites before running setup scripts
# Part of Galaxy J7 Mini Computer Conversion Project
# https://github.com/FlossWare/Samsung-Galaxy-J7

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Prerequisite Checker for Galaxy J7 Setup                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0
WARNINGS=0

# Check 1: ADB connection
echo "[1/6] Checking ADB connection..."
if ! command -v adb &> /dev/null; then
    echo "❌ ADB not found in PATH"
    ERRORS=$((ERRORS + 1))
elif ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ No Android device connected via ADB"
    echo "    - Enable USB Debugging on your phone"
    echo "    - Connect via USB and accept the authorization prompt"
    ERRORS=$((ERRORS + 1))
else
    DEVICE=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    echo "✅ ADB connected: $DEVICE"
fi

# Check 2: Device model
echo ""
echo "[2/6] Checking device model..."
MODEL=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
if [[ "$MODEL" == *"j7"* ]] || [[ "$MODEL" == *"J7"* ]]; then
    echo "✅ Samsung Galaxy J7 detected: $MODEL"
else
    echo "⚠️  Not a Galaxy J7 (found: $MODEL)"
    echo "    Scripts may work but package names might differ"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 3: Android version
echo ""
echo "[3/6] Checking Android version..."
ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
if [ -n "$ANDROID_VERSION" ]; then
    echo "✅ Android version: $ANDROID_VERSION"
    if [[ "$ANDROID_VERSION" != "8."* ]]; then
        echo "⚠️  Tested on Android 8.1.0, your version may behave differently"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  Could not detect Android version"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 4: Termux installation
echo ""
echo "[4/6] Checking Termux installation..."
if adb shell pm list packages 2>/dev/null | grep -q "com.termux"; then
    TERMUX_STATUS=$(adb shell pm list packages -e 2>/dev/null | grep com.termux)
    if [ -n "$TERMUX_STATUS" ]; then
        echo "✅ Termux is installed and enabled"
    else
        echo "⚠️  Termux is installed but disabled"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  Termux not installed"
    echo "    Install from: https://f-droid.org/packages/com.termux/"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 5: Storage information
echo ""
echo "[5/6] Checking storage..."
INTERNAL=$(adb shell df /data 2>/dev/null | tail -1 | awk '{print $4}')
if [ -n "$INTERNAL" ] && [ "$INTERNAL" -gt 0 ] 2>/dev/null; then
    INTERNAL_GB=$(awk "BEGIN {printf \"%.1f\", $INTERNAL / 1024 / 1024}")
    echo "✅ Internal storage free: ${INTERNAL_GB}GB"
fi

# Check for SD card
SDCARD=$(adb shell df 2>/dev/null | grep "/storage/.*-.*" | head -1 | awk '{print $4}')
if [ -n "$SDCARD" ] && [ "$SDCARD" -gt 0 ] 2>/dev/null; then
    SDCARD_GB=$(awk "BEGIN {printf \"%.1f\", $SDCARD / 1024 / 1024}")
    SDCARD_PATH=$(adb shell df 2>/dev/null | grep "/storage/.*-.*" | head -1 | awk '{print $6}')
    echo "✅ SD card found: ${SDCARD_GB}GB free at $SDCARD_PATH"
else
    echo "⚠️  No SD card detected"
    echo "    Insert SD card for Debian installation (requires ~1GB)"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 6: USB debugging and package management
echo ""
echo "[6/6] Checking USB debugging capabilities..."
TEST_PKG=$(adb shell pm list packages 2>/dev/null | head -1)
if [ -n "$TEST_PKG" ]; then
    echo "✅ Can query package list (USB debugging working)"
else
    echo "❌ Cannot access package manager"
    echo "    USB debugging may not be fully enabled"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Summary                                                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed! You're ready to proceed."
    echo ""
    echo "Next steps:"
    echo "  1. Run: bash scripts/aggressive_debloat.sh"
    echo "  2. Install Termux from F-Droid (if not already installed)"
    echo "  3. Run: bash scripts/termux_setup.sh"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  $WARNINGS warning(s) - you can proceed but review warnings above"
    exit 0
else
    echo "❌ $ERRORS error(s) and $WARNINGS warning(s) found"
    echo "    Fix errors before proceeding"
    exit 1
fi
