# Samsung Galaxy J7 Fleet Worker Setup Guide

**Last Updated:** 2026-07-02  
**Status:** ✅ WORKING - Fully autonomous fleet worker  
**Phones Configured:** android-j7-01 (complete)

---

## Overview

This guide shows how to set up a Samsung Galaxy J7 phone as an autonomous fleet worker node that:
- ✅ Auto-starts worker daemon on boot (port 9003)
- ✅ Auto-starts SSH server on boot (port 8022)
- ✅ Auto-starts fleet registration
- ✅ Requires only unlocking the phone after reboot (or no action if screen lock disabled)
- ✅ Works over WiFi (no USB required after setup)

---

## Prerequisites

### Required Apps (Install from F-Droid)
1. **Termux** (v0.118 or later)
   - Download: https://f-droid.org/en/packages/com.termux/
   - ⚠️ **Do NOT use Google Play version** (incompatible with Termux:Boot)

2. **Termux:Boot** (v0.7 or later)
   - Download: https://f-droid.org/en/packages/com.termux.boot/
   - Required for auto-start on boot

### Phone Settings
1. **Disable screen lock** (optional but recommended)
   - Settings → Security → Screen lock → None
   - Allows fully autonomous operation

2. **Disable battery optimization**
   - Settings → Battery → Battery Optimization
   - Set both Termux and Termux:Boot to "Not optimized"

3. **WiFi always on**
   - Settings → WiFi → Advanced → Keep WiFi on during sleep → Always

4. **Open Termux:Boot once**
   - Just launch the app (it has no UI, will close immediately)
   - This registers the boot receiver with Android

---

## Setup Steps

### 1. Install Termux Packages

Open Termux and run:

```bash
pkg update && pkg upgrade -y
pkg install -y python openssh iproute2
```

### 2. Deploy Worker Scripts

**Option A: Via laptop with USB (recommended)**

Connect phone via USB, then from laptop run:

```bash
# Run the setup script (will be provided)
./scripts/setup_fleet_node.sh android-j7-02
```

**Option B: Manual setup in Termux**

Copy the scripts from android-j7-01 or download from the repository.

Required files:
- `~/worker-daemon.py` - Worker HTTP daemon
- `~/worker-register.sh` - Fleet registration script
- `~/.termux/boot/start-worker` - Boot script

### 3. Setup SSH Keys

In Termux:

```bash
bash /sdcard/setup-ssh.sh
```

This will:
- Install openssh
- Add laptop SSH keys
- Start SSH server

### 4. Create Boot Script Directory

```bash
mkdir -p ~/.termux/boot
chmod 700 ~/.termux/boot
```

### 5. Copy and Configure Boot Script

```bash
cp /sdcard/start-worker ~/.termux/boot/
chmod +x ~/.termux/boot/start-worker
```

Edit `~/.termux/boot/start-worker` and set the hostname:
- android-j7-01, android-j7-02, etc.

### 6. Test Manual Start

```bash
export HOSTNAME=android-j7-02
python ~/worker-daemon.py &
```

Check if it's running:
```bash
curl http://localhost:9003/health
```

### 7. Test Boot Script

Reboot the phone:
- Unlock the phone (if screen lock enabled)
- Wait 90 seconds
- Test SSH: `ssh -p 8022 <phone-ip>`
- Test daemon: `curl http://<phone-ip>:9003/health`

---

## Configuration

### Worker Daemon

**Port:** 9003  
**File:** `~/worker-daemon.py`  
**Features:**
- HTTP API with /health, /execute, /deploy endpoints
- Exponential backoff retry (3s, 5s, 10s, 15s, 20s)
- No authentication (home lab mode)
- Allowed commands: python3, node, worker-client.sh, worker-register.sh

**Key Settings:**
```python
PORT = 9003
MAX_RETRIES = 5
RETRY_DELAYS = [3, 5, 10, 15, 20]
```

### SSH Server

**Port:** 8022 (Termux default)  
**Auth:** Public key only (passwordless)  
**Auto-start:** Yes (via boot script)

**Connect from laptop:**
```bash
ssh -p 8022 <phone-ip>
```

### Fleet Registration

**Registry URL:** http://aio-01:8004  
**File:** `~/worker-register.sh`  
**Hostname:** Set via HOSTNAME environment variable  
**Heartbeat:** Every 4 seconds

---

## Boot Process Timeline

1. **0s:** Phone powered on
2. **30-60s:** Android boot complete
3. **User action:** Unlock phone (only if screen lock enabled)
4. **+5s:** Termux:Boot triggers
5. **+0s:** SSH server starts
6. **+2s:** Kill old processes
7. **+3s:** Wait for network (up to 60s)
8. **+30s:** Network stabilization delay
9. **+2s:** Worker daemon starts
10. **+3s:** Registration starts
11. **Total:** ~90 seconds from power-on to fully operational

---

## Verification

### Check Auto-Start Status

```bash
# From laptop
ssh -p 8022 <phone-ip> "tail -20 ~/boot.log"

# Check daemon
curl http://<phone-ip>:9003/health

# Check processes
ssh -p 8022 <phone-ip> "ps | grep -E 'python|sshd|worker'"
```

### Check Logs

```bash
# Boot log
ssh -p 8022 <phone-ip> "cat ~/boot.log"

# Daemon log
ssh -p 8022 <phone-ip> "cat ~/worker-daemon.log"

# Registration log
ssh -p 8022 <phone-ip> "cat ~/worker-register.log"
```

---

## Network Configuration

### IP Addresses
- android-j7-01: 192.168.1.248
- android-j7-02: (TBD)

### Ports
- 8022: SSH server
- 9003: Worker daemon HTTP API

### Fleet Orchestrator
- URL: http://aio-01:8004
- Endpoints: /register, /heartbeat, /workers

---

## Power Management

### Recommended Setup
- Keep phone plugged into USB power 24/7
- Battery will not degrade significantly (Android manages charging)
- Use shortest screen timeout to save battery
- WiFi always on (even when screen off)

### Battery Removal
- Samsung Galaxy J7 has removable battery
- ⚠️ Phone will NOT boot without battery installed
- Keep battery in, leave plugged in

---

## Troubleshooting

### Worker daemon not starting

```bash
# Check daemon log
ssh -p 8022 <phone-ip> "tail -30 ~/worker-daemon.log"

# Start manually to see errors
ssh -p 8022 <phone-ip> "python ~/worker-daemon.py"
```

Common issues:
- Port 8003 blocked (use port 9003 instead)
- Network not ready (increase delay in boot script)
- Python not installed (`pkg install python`)

### SSH not starting

```bash
# Check if sshd is installed
ssh -p 8022 <phone-ip> "which sshd"

# Check boot log
ssh -p 8022 <phone-ip> "grep -i ssh ~/boot.log"

# Start manually
ssh -p 8022 <phone-ip> "sshd"
```

### Registration failing

```bash
# Check registration log
ssh -p 8022 <phone-ip> "tail -20 ~/worker-register.log"

# Test fleet API
curl http://aio-01:8004/workers

# Test registration manually
ssh -p 8022 <phone-ip> "export HOSTNAME=android-j7-01 && ./worker-register.sh"
```

### Phone loses WiFi when unplugged

Settings to check:
1. WiFi → Advanced → Keep WiFi on during sleep → **Always**
2. Battery → Battery Optimization → Termux → **Not optimized**
3. Keep phone plugged in permanently for fleet worker use

---

## Files

### On Phone (Termux home directory)

```
~/
├── worker-daemon.py           # Worker HTTP daemon (port 9003)
├── worker-register.sh         # Fleet registration script
├── boot.log                   # Boot script log
├── worker-daemon.log          # Daemon error log
├── worker-register.log        # Registration log
└── .termux/
    ├── boot/
    │   └── start-worker       # Boot script (auto-runs)
    └── .ssh/
        └── authorized_keys    # SSH public keys
```

### On Laptop (Development)

```
Samsung-Galaxy-J7/
├── README.md                  # Quick reference
├── SETUP_GUIDE.md            # This file
├── CRITICAL_WARNINGS.md      # Lessons learned
├── scripts/
│   ├── setup_fleet_node.sh   # Automated setup
│   ├── disable_autostart_apps.sh
│   └── cleanup_internal_storage_aggressive.sh
└── docs/
    └── various status files
```

---

## Known Issues

### Port 8003 "Address already in use"
- **Cause:** Unknown (possibly Android system service)
- **Solution:** Use port 9003 instead
- **Status:** Resolved by changing PORT in worker-daemon.py

### Fleet API Database Permissions
- **Issue:** aio-01:8004 returns "Internal Server Error"
- **Cause:** PostgreSQL permission denied for schema fleet
- **Impact:** Workers can't register with fleet
- **Status:** Infrastructure issue (not phone issue)

---

## Success Criteria

✅ **Worker daemon auto-starts on boot**  
✅ **SSH server auto-starts on boot**  
✅ **Survives reboot autonomously**  
✅ **Accessible via WiFi (no USB needed)**  
✅ **Only manual step: unlock phone** (or none if screen lock disabled)  

---

## Next Steps

1. Configure android-j7-02 using this guide
2. Fix fleet API database permissions on aio-01
3. Test worker task execution from orchestrator
4. Add more phones to fleet (android-j7-03, etc.)

---

## References

- Termux: https://termux.dev/
- Termux:Boot: https://termuxtools.com/termux-boot-autorun-scripts/
- F-Droid: https://f-droid.org/

---

**Last tested:** 2026-07-02 with android-j7-01  
**Status:** ✅ Fully working and autonomous
