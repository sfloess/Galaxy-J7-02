#!/bin/bash
# Hide all disabled packages so they don't show up for updates
# This uninstalls packages for the current user while keeping them in system

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Hide Disabled Packages from Updates                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "This will convert disabled packages to 'uninstalled for user'."
echo ""
echo "Benefits:"
echo "  ✅ Packages won't show in Play Store updates"
echo "  ✅ Saves even more storage space"
echo "  ✅ Prevents accidental re-enabling"
echo "  ✅ Easily reversible with: adb shell cmd package install-existing PACKAGE"
echo ""
echo "Current disabled packages: $(adb shell pm list packages -d | wc -l)"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo ""
echo "🗑️  Uninstalling disabled packages for current user..."
echo "   (Keeps packages in system for easy restore)"
echo ""

# Get list of disabled packages
DISABLED_PACKAGES=$(adb shell pm list packages -d | sed 's/package://')

COUNT=0
FAILED=0

for PACKAGE in $DISABLED_PACKAGES; do
    echo -n "  Uninstalling: $PACKAGE ... "

    # Uninstall for user 0, keep data (-k flag)
    RESULT=$(adb shell pm uninstall -k --user 0 "$PACKAGE" 2>&1)

    if [[ $RESULT == *"Success"* ]]; then
        echo "✅"
        ((COUNT++))
    else
        echo "⚠️  (already uninstalled or system)"
        ((FAILED++))
    fi
done

echo ""
echo "✅ Complete!"
echo ""
echo "📊 Results:"
echo "   Successfully uninstalled: $COUNT packages"
echo "   Already uninstalled/system: $FAILED packages"
echo ""
echo "🎯 Benefits achieved:"
echo "   ✅ No more update prompts for these apps"
echo "   ✅ Not visible in Play Store app list"
echo "   ✅ Additional storage space freed"
echo "   ✅ Can't be accidentally re-enabled from Settings"
echo ""
echo "📝 To restore any package:"
echo "   adb shell cmd package install-existing PACKAGE_NAME"
echo ""
echo "Example:"
echo "   adb shell cmd package install-existing com.google.android.gm"
echo ""
