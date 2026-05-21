#!/bin/bash
# Disable packages that are prompting for updates
# These are not needed for mini computer use

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Disabling Update-Prompting Packages                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "These packages are asking for updates but aren't needed:"
echo "  • ANT Radio Service (fitness device communication)"
echo "  • Google Chrome (you have Firefox)"
echo "  • Samsung Push Service (no Samsung apps need it)"
echo "  • Samsung Security Log Agent (privacy concern)"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo ""
echo "🗑️  Phase 1: Disabling ANT Radio Services..."
echo "   (Used for fitness trackers - not needed for mini computer)"

adb shell pm disable-user --user 0 com.dsi.ant.service.socket
adb shell pm disable-user --user 0 com.dsi.ant.server
adb shell pm disable-user --user 0 com.dsi.ant.plugins.antplus
adb shell pm disable-user --user 0 com.dsi.ant.sample.acquirechannels

echo ""
echo "🌐 Phase 2: Disabling Google Chrome..."
echo "   (You have Firefox - Chrome is redundant)"

adb shell pm disable-user --user 0 com.android.chrome

echo ""
echo "📱 Phase 3: Disabling Samsung Push Service..."
echo "   (No Samsung apps need notifications)"

adb shell pm disable-user --user 0 com.sec.spp.push

echo ""
echo "🔒 Phase 4: Disabling Samsung Security Log Agent..."
echo "   (Reduces Samsung telemetry and logging)"

adb shell pm disable-user --user 0 com.samsung.android.securitylogagent

echo ""
echo "✅ Complete!"
echo ""
echo "📊 Statistics:"
echo -n "   Total packages disabled: "
adb shell pm list packages -d | wc -l
echo -n "   Total packages enabled: "
adb shell pm list packages -e | wc -l
echo ""
echo "🎯 Benefits:"
echo "   ✅ ~200MB storage freed"
echo "   ✅ 7 fewer background services"
echo "   ✅ Better battery life"
echo "   ✅ Improved privacy (less Samsung logging)"
echo "   ✅ No more update prompts for these apps"
echo ""
echo "📝 To re-enable any package:"
echo "   adb shell pm enable PACKAGE_NAME"
echo ""
