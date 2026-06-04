#!/bin/bash
# Quarterly Deep Storage Cleanup Script
# Run this every 3 months for maximum space recovery
# Estimated time: 10 minutes
# WARNING: Clears Google Play Services data (requires re-login)

echo "🧹 Quarterly Deep Storage Cleanup"
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

# Warning about Google Play Services
echo "⚠️  WARNING: This will clear Google Play Services data"
echo "   - You will need to re-login to Google accounts"
echo "   - Play Store, Gmail, Chrome sync will require sign-in"
echo "   - This typically frees 300MB-2GB of space"
echo ""

read -p "Continue with deep cleanup? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled. Running regular cleanup instead..."
    echo ""

    # Run monthly cleanup instead
    if [ -f "$(dirname "$0")/monthly_cleanup.sh" ]; then
        bash "$(dirname "$0")/monthly_cleanup.sh"
    else
        echo "Monthly cleanup script not found. Exiting."
    fi
    exit 0
fi

echo ""
echo "🗑️  Phase 1: Clear Google Play Services Data"
echo "-----------------------------------"

echo -n "  Clearing Google Play Services... "
if adb shell pm clear com.google.android.gms 2>&1 | grep -q "Success"; then
    echo "✓ (requires re-login)"
else
    echo "✗ Failed"
fi

echo ""
echo "🗑️  Phase 2: Clear All App Caches"
echo "-----------------------------------"

# Apps to skip (consistent with other scripts)
SKIP_APPS="com.teslacoilsw.launcher com.alphainventor.filemanager com.authy.authy org.fedorahosted.freeotp com.android.vending com.google.android.gms de.blinkt.openvpn"

# List of all installed user apps
APPS=$(adb shell pm list packages -3 | cut -d: -f2)
CACHE_COUNT=0
CACHE_SKIPPED=0

for app in $APPS; do
    # Skip protected apps (GMS already cleared in Phase 1, others are critical)
    if echo "$SKIP_APPS" | grep -q "$app"; then
        echo -n "  $app... "
        echo "⊘ Skipped (protected app)"
        ((CACHE_SKIPPED++))
        continue
    fi

    echo -n "  $app... "
    adb shell pm clear "$app" --cache-only 2>&1 | grep -q "Success" && echo "✓" || echo "✗"
    ((CACHE_COUNT++))
done

echo ""
echo "App caches: $CACHE_COUNT cleared, $CACHE_SKIPPED protected"

echo ""
echo "🗑️  Phase 3: Deep System Cleanup"
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

echo -n "  Old APK files in Downloads... "
COUNT=$(adb shell "find /sdcard/Download -name '*.apk' 2>/dev/null | wc -l")
adb shell "find /sdcard/Download -name '*.apk' -delete 2>/dev/null"
echo "✓ ($COUNT removed)"

echo -n "  Old backup files... "
adb shell "find /sdcard -name '*.bak' -delete 2>/dev/null"
adb shell "find /sdcard -name '*backup*.zip' -mtime +30 -delete 2>/dev/null"
echo "✓"

echo ""
echo "🗑️  Phase 4: Review Large Files"
echo "-----------------------------------"

echo "Largest files on internal storage:"
adb shell "find /sdcard -type f -size +5M 2>/dev/null -exec ls -lh {} \;" | awk '{print $5, $NF}' | head -10

echo ""
echo "=========================================="
echo "✅ Quarterly Deep Cleanup Complete!"
echo ""

# Show final storage
echo "📊 Storage After Cleanup:"
adb shell df -h | grep "/data" | head -1
echo ""

# Detailed storage breakdown
echo "📊 Detailed Storage Breakdown:"
adb shell dumpsys diskstats 2>/dev/null | grep -E "Data-Free|App Size|App Data|Cache|Photos|Videos|Audio|Downloads|System|Other"

echo ""
echo "=========================================="
echo "📝 Post-Cleanup Actions Required:"
echo "=========================================="
echo ""
echo "1. ✓ Re-login to Google Play Store"
echo "   - Open Play Store → Sign in"
echo ""
echo "2. ✓ Re-login to Gmail (if installed)"
echo "   - Open Gmail → Sign in"
echo ""
echo "3. ✓ Re-login to Chrome"
echo "   - Open Chrome → Sign in → Enable sync"
echo ""
echo "4. ✓ Test camera"
echo "   - Open Camera app → Take test photo"
echo ""
echo "5. ✓ Verify Termux/SSH"
echo "   - SSH to phone: ssh -p 8022 <phone-ip>"
echo ""
echo "=========================================="
echo "📅 Maintenance Schedule:"
echo "=========================================="
echo ""
echo "  Weekly:    Run weekly_cleanup.sh"
echo "  Monthly:   Run monthly_cleanup.sh"
echo "  Quarterly: Run this script (every 3 months)"
echo ""
echo "💾 Expected free space: 2-3GB after cleanup"
echo "💾 Sustainable range: 1.5-2GB with regular maintenance"
echo ""
