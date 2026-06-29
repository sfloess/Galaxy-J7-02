#!/bin/bash
# Monthly Storage Cleanup Script
# Run this monthly for deeper cleaning
# Estimated time: 5 minutes

set -euo pipefail

echo "🧹 Monthly Storage Cleanup"
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

echo "🗑️  Phase 1: Clear All App Caches"
echo "-----------------------------------"

echo -n "  Chrome cache... "
adb shell pm clear com.android.chrome --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"

echo -n "  Firefox cache... "
adb shell pm clear org.mozilla.firefox --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"

echo -n "  Nova Launcher cache... "
echo "⊘ Skipped (preserving launcher settings)"

echo -n "  Reolink cache... "
adb shell pm clear com.mcu.reolink --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"

echo -n "  KDE Connect cache... "
adb shell pm clear org.kde.kdeconnect_tp --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"

echo -n "  File Manager cache... "
echo "⊘ Skipped (preserving remote server connections)"

echo -n "  DroidCam cache... "
adb shell pm clear com.dev47apps.obsdroidcam --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"

echo ""
echo "ℹ️  PROTECTED (never cleared): Nova, File Manager, Authy, FreeOTP"

echo -n "  Google Play Services cache... "
echo "⊘ Skipped (requires re-login if cleared)"

echo ""
echo "🗑️  Phase 2: Clean System Files"
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
echo "🗑️  Phase 3: Review Download Folder"
echo "-----------------------------------"

# Single adb call - capture listing and derive count from it
LISTING=$(adb shell "ls -lh /sdcard/Download/ 2>/dev/null | awk 'NR>1 {print \$5, \$NF}'")

# Count files (handle empty directory case)
if [[ -z "$LISTING" ]]; then
    TOTAL_FILES=0
else
    TOTAL_FILES=$(echo "$LISTING" | wc -l)
fi

echo "Total files in Download folder: $TOTAL_FILES"
echo ""
echo "Largest files (showing top 20):"
# Sort on host side where we guarantee GNU coreutils support
echo "$LISTING" | sort -rh | head -20

if [ "$TOTAL_FILES" -gt 20 ]; then
    echo ""
    echo "💡 Note: $((TOTAL_FILES - 20)) more files not shown"
fi

echo ""
echo "💡 Tip: Manually review /sdcard/Download/ for files to delete"

echo ""
echo "=========================================="
echo "✅ Monthly Cleanup Complete!"
echo ""

# Show final storage
echo "📊 Storage After Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

# Detailed storage breakdown
echo "📊 Detailed Storage Breakdown:"
adb shell dumpsys diskstats 2>/dev/null | grep -E "Data-Free|App Size|App Data|Cache|Photos|Videos|Audio|Downloads" | head -8

echo ""
echo "📅 Next Actions:"
echo "  - Run weekly_cleanup.sh every week"
echo "  - Run this script monthly"
echo "  - Run quarterly_cleanup.sh every 3 months for deep clean"
echo ""

# Count installed apps
TOTAL_APPS=$(adb shell pm list packages | wc -l)
USER_APPS=$(adb shell pm list packages -3 | wc -l)
echo "📦 Apps: $USER_APPS user apps, $TOTAL_APPS total packages"
echo ""
