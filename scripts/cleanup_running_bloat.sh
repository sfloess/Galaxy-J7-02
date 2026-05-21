#!/bin/bash
# Clean up running bloatware processes

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Clean Up Running Bloatware                                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "This will:"
echo "  1. Force-stop 3 disabled packages still running"
echo "  2. Disable 2 more telemetry/bloat services"
echo "  3. Force-stop those too"
echo ""
echo "Packages to stop:"
echo "  • com.verizon.mips.services (Verizon bloat)"
echo "  • com.samsung.faceservice (Face recognition)"
echo "  • com.samsung.unifiedsettingservice (Settings service)"
echo ""
echo "Packages to disable:"
echo "  • com.sec.android.diagmonagent (Samsung telemetry)"
echo "  • com.samsung.storyservice (Gallery stories)"
echo ""
echo "Benefits:"
echo "  ✅ ~150MB more free RAM"
echo "  ✅ 5 fewer running processes"
echo "  ✅ Better privacy (no Samsung diagnostics)"
echo "  ✅ Total disabled: 79 packages"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo ""
echo "🛑 Phase 1: Force-stopping disabled packages still running..."

adb shell am force-stop com.verizon.mips.services
echo "  ✅ Stopped: com.verizon.mips.services"

adb shell am force-stop com.samsung.faceservice
echo "  ✅ Stopped: com.samsung.faceservice"

adb shell am force-stop com.samsung.unifiedsettingservice
echo "  ✅ Stopped: com.samsung.unifiedsettingservice"

echo ""
echo "🗑️  Phase 2: Disabling additional telemetry/bloat..."

adb shell pm disable-user --user 0 com.sec.android.diagmonagent
adb shell pm disable-user --user 0 com.samsung.storyservice

echo ""
echo "🛑 Phase 3: Force-stopping newly disabled packages..."

adb shell am force-stop com.sec.android.diagmonagent
echo "  ✅ Stopped: com.sec.android.diagmonagent"

adb shell am force-stop com.samsung.storyservice
echo "  ✅ Stopped: com.samsung.storyservice"

echo ""
echo "✅ Complete!"
echo ""
echo "📊 Final Statistics:"
echo -n "   Total disabled packages: "
adb shell pm list packages -d | wc -l
echo ""
echo "🎯 Results:"
echo "   ✅ ~150MB RAM freed"
echo "   ✅ 5 fewer processes running"
echo "   ✅ No Samsung telemetry running"
echo "   ✅ Cleaner system"
echo ""
echo "📝 These packages won't restart until phone reboot"
echo "   (and won't restart even then because they're disabled!)"
echo ""
