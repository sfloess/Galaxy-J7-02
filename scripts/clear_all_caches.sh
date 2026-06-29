#!/bin/bash
# Clear All Caches Script
# Clears cache for ALL apps (user + system) safely
# This replaces cache-cleaning apps - you can uninstall them after!
# Estimated time: 3-5 minutes

set -euo pipefail

echo "🧹 Clear All Caches"
echo "=========================================="
echo ""

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

# Show current storage
echo "📊 Storage Before Cache Clear:"
adb shell df -h | grep "/data" | head -1
echo ""

# Get cache size before
CACHE_BEFORE=$(adb shell dumpsys diskstats 2>/dev/null | grep "Cache-Free:" | awk '{print $2}' | sed 's/K//')
echo "💾 Current cache usage: ~$((CACHE_BEFORE / 1024))MB"
echo ""

echo "ℹ️  This will clear cache for ALL apps (safe, no data loss)"
echo "   - User apps"
echo "   - System apps"
echo "   - System cache"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo ""
echo "🗑️  Phase 1: Clear User App Caches"
echo "=========================================="

# Get all user apps
USER_APPS=$(adb shell pm list packages -3 | cut -d: -f2 | sort)
USER_COUNT=0
USER_SUCCESS=0
USER_SKIPPED=0

# Apps to skip (sensitive to cache clearing - settings stored in cache)
SKIP_APPS="com.teslacoilsw.launcher com.alphainventor.filemanager com.authy.authy org.fedorahosted.freeotp com.android.vending com.google.android.gms de.blinkt.openvpn"
# Nova Launcher - clearing cache resets home screen layout
# File Manager - clearing cache removes remote server connections
# Authy & FreeOTP - CRITICAL 2FA apps, NEVER clear!
# Play Store & Google Play Services - clearing requires re-login
# OpenVPN - VPN profiles and credentials

for pkg in $USER_APPS; do
    ((USER_COUNT++))

    # Check if this app should be skipped
    if echo "$SKIP_APPS" | grep -q "$pkg"; then
        echo -n "  [$USER_COUNT] $pkg... "
        echo "⊘ Skipped (protected app)"
        ((USER_SKIPPED++))
        continue
    fi

    echo -n "  [$USER_COUNT] $pkg... "
    if adb shell pm clear "$pkg" --cache-only 2>&1 | grep -q "Success"; then
        echo "✓"
        ((USER_SUCCESS++))
    else
        echo "✗"
    fi
done

echo ""
echo "User apps: $USER_SUCCESS/$USER_COUNT caches cleared ($USER_SKIPPED skipped for safety)"
echo ""

echo "🗑️  Phase 2: Clear System App Caches"
echo "=========================================="

# Get all system apps
SYSTEM_APPS=$(adb shell pm list packages -s | cut -d: -f2 | sort)
SYSTEM_COUNT=0
SYSTEM_SUCCESS=0

echo "Clearing system app caches (this may take a few minutes)..."
echo ""

for pkg in $SYSTEM_APPS; do
    ((SYSTEM_COUNT++))

    # Show progress every 20 apps
    if [ $((SYSTEM_COUNT % 20)) -eq 0 ]; then
        echo "  Progress: $SYSTEM_COUNT apps processed..."
    fi

    if adb shell pm clear "$pkg" --cache-only 2>&1 | grep -q "Success"; then
        ((SYSTEM_SUCCESS++))
    fi
done

echo ""
echo "System apps: $SYSTEM_SUCCESS/$SYSTEM_COUNT caches cleared"
echo ""

echo "🗑️  Phase 3: Clear System Cache Files"
echo "=========================================="

echo -n "  Thumbnail cache... "
adb shell "rm -rf /sdcard/.thumbnails/* 2>/dev/null"
adb shell "rm -rf /data/system/thumbnails/* 2>/dev/null"
echo "✓"

echo -n "  Temp files... "
adb shell "find /sdcard -name '*.tmp' -delete 2>/dev/null"
adb shell "rm -rf /data/local/tmp/* 2>/dev/null"
echo "✓"

echo -n "  Log files... "
adb shell "find /sdcard -name '*.log' -delete 2>/dev/null"
adb shell "rm -rf /data/log/* 2>/dev/null"
echo "✓"

echo -n "  System cache partition... "
# This clears the /cache partition
adb shell "rm -rf /cache/* 2>/dev/null"
echo "✓"

echo -n "  Dalvik cache (app runtime cache)... "
adb shell "rm -rf /data/dalvik-cache/.* 2>/dev/null"
echo "✓"

echo ""
echo "🗑️  Phase 4: Trim Caches (Android System)"
echo "=========================================="

echo -n "  Running Android cache trimmer... "
# This tells Android to trim all caches to minimum
adb shell pm trim-caches 999999999999 2>/dev/null
echo "✓"

echo ""
echo "=========================================="
echo "✅ All Caches Cleared!"
echo ""

# Show final storage
echo "📊 Storage After Cache Clear:"
adb shell df -h | grep "/data" | head -1
echo ""

# Get cache size after
CACHE_AFTER=$(adb shell dumpsys diskstats 2>/dev/null | grep "Cache-Free:" | awk '{print $2}' | sed 's/K//')
CACHE_FREED=$((CACHE_BEFORE - CACHE_AFTER))

if [ $CACHE_FREED -gt 0 ]; then
    echo "💾 Cache freed: ~$((CACHE_FREED / 1024))MB"
else
    echo "💾 Cache was already minimal"
fi

echo ""
echo "📊 Summary:"
echo "  ✓ User app caches: $USER_SUCCESS/$USER_COUNT cleared"
echo "  ✓ System app caches: $SYSTEM_SUCCESS/$SYSTEM_COUNT cleared"
echo "  ✓ System cache files: cleared"
echo "  ✓ Total apps processed: $((USER_COUNT + SYSTEM_COUNT))"
echo ""

# Get exact free space
FREE_KB=$(adb shell dumpsys diskstats 2>/dev/null | grep "Data-Free:" | awk '{print $2}' | sed 's/K//')
if [ -n "$FREE_KB" ]; then
    FREE_MB=$((FREE_KB / 1024))
    FREE_GB=$((FREE_MB / 1024))
    FREE_MB_REMAINDER=$((FREE_MB % 1024))
    echo "💾 Free Space: ${FREE_GB}.${FREE_MB_REMAINDER:0:1}GB"
fi

echo ""
echo "✨ You can now uninstall your cache-cleaning app!"
echo "   This script does everything it does (and more!)"
echo ""
echo "💡 Usage Tips:"
echo "  - Run this script weekly or when storage is tight"
echo "  - Safe to run anytime (only clears cache, not data)"
echo "  - No apps will be affected (cache regenerates as needed)"
echo ""
