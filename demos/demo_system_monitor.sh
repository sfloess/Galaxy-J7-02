#!/data/data/com.termux/files/usr/bin/bash
# System Monitor Demo
# Shows real-time system information

clear

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   System Monitor - Press Ctrl+C to exit                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

while true; do
    clear
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║   System Monitor - $(date +'%Y-%m-%d %H:%M:%S')           ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    # CPU Information
    echo "💻 CPU Information:"
    cat /proc/cpuinfo | grep "model name" | head -1 | cut -d: -f2
    echo ""

    # Memory Usage
    echo "💾 Memory Usage:"
    free -h | grep -v "^Swap"
    echo ""

    # Storage Usage
    echo "💿 Storage Usage:"
    df -h ~ | tail -1 | awk '{print "   Home: " $3 " / " $2 " (" $5 " used)"}'
    df -h /sdcard 2>/dev/null | tail -1 | awk '{print "   SD Card: " $3 " / " $2 " (" $5 " used)"}'
    echo ""

    # Network Information
    echo "📡 Network:"
    IP=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d: -f2)
    if [ ! -z "$IP" ]; then
        echo "   IP Address: $IP"
    else
        echo "   WiFi: Not connected"
    fi
    echo ""

    # Battery (if termux-api installed)
    if command -v termux-battery-status &> /dev/null; then
        echo "🔋 Battery:"
        termux-battery-status | grep -E "percentage|status" | sed 's/[",]//g' | awk -F: '{print "   " $1 ": " $2}'
        echo ""
    fi

    # Top Processes
    echo "⚙️  Top 5 Processes:"
    ps aux | sort -rk 3 | head -6 | tail -5 | awk '{printf "   %-20s %5s%%  %s\n", substr($11,1,20), $3, $2}'
    echo ""

    # Uptime
    echo "⏱️  Uptime:"
    uptime | awk -F'up ' '{print "   " $2}' | awk -F',' '{print "   " $1}'
    echo ""

    echo "Press Ctrl+C to exit..."

    sleep 2
done
