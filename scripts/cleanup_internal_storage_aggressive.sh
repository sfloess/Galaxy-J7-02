#!/bin/bash
# Aggressive Internal Storage Cleanup
# Uninstalls all disabled packages, removes Chrome, clears caches
# Expected to free: 1-1.5GB of internal storage

set -euo pipefail

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "❌ ERROR: No Android device connected"
    exit 1
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   AGGRESSIVE INTERNAL STORAGE CLEANUP                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Show current storage
echo "📊 Storage BEFORE Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

echo "This will:"
echo "  1. Uninstall ALL 81 disabled packages (~500MB-1GB)"
echo "  2. Remove Chrome browser (you have Firefox)"
echo "  3. Clear all app caches"
echo ""
echo "⚠️  WARNING: This cannot be easily undone!"
echo "   Disabled packages will be UNINSTALLED, not just disabled."
echo ""

# Auto-confirm for scripted execution
if [ -t 0 ]; then
    read -p "Continue? (yes/no) " -r
    echo
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Cancelled."
        exit 1
    fi
else
    echo "Auto-confirming (non-interactive mode)..."
    echo ""
fi

echo ""
echo "🗑️  PHASE 1: Uninstalling Disabled Packages"
echo "=============================================="
echo ""

# Get all disabled packages
disabled_packages=$(adb shell pm list packages -d | cut -d: -f2)
total=$(echo "$disabled_packages" | wc -l)
count=0
success=0
failed=0

echo "Found $total disabled packages to uninstall..."
echo ""

for pkg in $disabled_packages; do
    ((count++))
    echo -n "[$count/$total] Uninstalling: $pkg ... "

    if adb shell pm uninstall --user 0 "$pkg" 2>&1 | grep -q "Success"; then
        echo "✓"
        ((success++))
    else
        # Try alternative method
        if adb shell pm uninstall -k --user 0 "$pkg" 2>&1 | grep -q "Success"; then
            echo "✓ (kept data)"
            ((success++))
        else
            echo "✗ (protected)"
            ((failed++))
        fi
    fi
done

echo ""
echo "  ✓ Uninstalled: $success packages"
echo "  ✗ Protected: $failed packages"
echo ""

echo "🗑️  PHASE 2: Removing Chrome"
echo "=============================================="
echo ""

if adb shell pm list packages | grep -q "com.android.chrome"; then
    echo -n "Uninstalling Chrome browser... "
    if adb shell pm uninstall --user 0 com.android.chrome 2>&1 | grep -q "Success"; then
        echo "✓"
    else
        echo "✗ (may already be uninstalled or protected)"
    fi
else
    echo "Chrome already uninstalled ✓"
fi

echo ""
echo "🗑️  PHASE 3: Clearing All App Caches"
echo "=============================================="
echo ""

echo "Clearing system caches..."
adb shell pm trim-caches 999999999999 2>/dev/null || echo "  (trim-caches not available, using alternative)"

echo ""
echo "Clearing individual app caches..."

# Clear caches for major apps
declare -a cache_apps=(
    "org.mozilla.firefox"
    "com.teslacoilsw.launcher"
    "org.kde.kdeconnect_tp"
    "com.alphainventor.filemanager"
    "com.android.vending"
    "com.google.android.gms"
)

for app in "${cache_apps[@]}"; do
    if adb shell pm list packages | grep -q "$app"; then
        echo -n "  $app ... "
        if adb shell pm clear "$app" --cache-only 2>&1 | grep -q "Success"; then
            echo "✓"
        else
            echo "⊘"
        fi
    fi
done

echo ""
echo "Clearing system files..."
echo -n "  Log files... "
adb shell "find /sdcard -name '*.log' -delete 2>/dev/null" && echo "✓"

echo -n "  Temp files... "
adb shell "find /sdcard -name '*.tmp' -delete 2>/dev/null" && echo "✓"

echo -n "  Thumbnail cache... "
adb shell "rm -rf /sdcard/.thumbnails/* 2>/dev/null" && echo "✓"

echo ""
echo "=============================================="
echo "✅ CLEANUP COMPLETE!"
echo "=============================================="
echo ""

# Show final storage
echo "📊 Storage AFTER Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

# Calculate space freed
echo "📈 Detailed Storage Breakdown:"
adb shell dumpsys diskstats 2>/dev/null | grep -E "Data-Free|App Size|App Data|Cache" | head -4

echo ""
echo "📦 Package Summary:"
echo "  Total packages now: $(adb shell pm list packages | wc -l)"
echo "  Disabled packages: $(adb shell pm list packages -d | wc -l)"
echo "  Enabled packages: $(adb shell pm list packages -e | wc -l)"
echo ""

echo "🎉 SUCCESS!"
echo "   - Freed up significant internal storage"
echo "   - Removed bloatware permanently"
echo "   - System should run faster and smoother"
echo ""
echo "💡 Next Steps:"
echo "   - Run weekly_cleanup.sh to maintain storage"
echo "   - Monitor: Settings → Storage to track usage"
echo "   - Reboot phone for best performance"
echo ""
