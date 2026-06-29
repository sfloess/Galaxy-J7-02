#!/bin/bash
# Weekly Storage Cleanup Script
# Run this weekly to maintain optimal storage levels
# Estimated time: 2 minutes

set -euo pipefail

echo "🧹 Weekly Storage Cleanup"
echo "=========================================="
echo ""

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

# Show current storage
echo "📊 Storage Before Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

echo "🗑️  Phase 1: Clear Browser Caches"
echo "-----------------------------------"

echo -n "  Chrome cache... "
if adb shell pm clear com.android.chrome --cache-only 2>&1 | grep -q "Success"; then
    echo "✓"
else
    echo "✗ (not installed or already clear)"
fi

echo -n "  Firefox cache... "
if adb shell pm clear org.mozilla.firefox --cache-only 2>&1 | grep -q "Success"; then
    echo "✓"
else
    echo "✗ (not installed or already clear)"
fi

echo ""
echo "ℹ️  Note: Skipping Nova Launcher to preserve settings"
echo ""
echo "🗑️  Phase 2: Clean Temporary Files"
echo "-----------------------------------"

echo -n "  Log files... "
adb shell "find /sdcard -name '*.log' -delete 2>/dev/null"
echo "✓"

echo -n "  Temp files... "
adb shell "find /sdcard -name '*.tmp' -delete 2>/dev/null"
echo "✓"

echo -n "  Thumbnail cache... "
adb shell "rm -rf /sdcard/.thumbnails/* 2>/dev/null"
echo "✓"

echo ""
echo "=========================================="
echo "✅ Weekly Cleanup Complete!"
echo ""

# Show final storage
echo "📊 Storage After Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

# Get exact free space
FREE_KB=$(adb shell dumpsys diskstats 2>/dev/null | grep "Data-Free:" | awk '{print $2}' | cut -d'K' -f1)
if [ -n "$FREE_KB" ]; then
    FREE_MB=$((FREE_KB / 1024))
    FREE_GB=$((FREE_MB / 1024))
    echo "💾 Free Space: ${FREE_GB}.${FREE_MB:0:1}GB"
fi

echo ""
echo "📅 Next Actions:"
echo "  - Run this script weekly"
echo "  - Run monthly_cleanup.sh at end of month"
echo "  - Monitor storage levels"
echo ""
