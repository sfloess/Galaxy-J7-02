# Storage Maintenance Guide
**Device**: Samsung Galaxy J7 (SM-J727V)  
**Created**: 2026-05-26

---

## 📅 Maintenance Schedule

### **Weekly** (2 minutes)
```bash
./scripts/weekly_cleanup.sh
```

**What it does**:
- ✓ Clears browser caches (Chrome, Firefox)
- ✓ Removes log files
- ✓ Deletes temp files
- ✓ Clears thumbnail cache

**Expected savings**: 20-50MB per week  
**Frequency**: Every week (set a calendar reminder!)

---

### **Monthly** (5 minutes)
```bash
./scripts/monthly_cleanup.sh
```

**What it does**:
- ✓ All weekly cleanup tasks
- ✓ Clears ALL app caches (Nova, Reolink, KDE Connect, etc.)
- ✓ Shows files in Download folder for manual review
- ✓ Detailed storage report

**Expected savings**: 50-100MB per month  
**Frequency**: End of each month

---

### **Quarterly** (10 minutes)
```bash
./scripts/quarterly_cleanup.sh
```

**What it does**:
- ✓ All monthly cleanup tasks
- ✓ **Clears Google Play Services data** (big space saver!)
- ✓ Deep system cleanup
- ✓ Removes old APK files
- ✓ Shows largest files for review

**Expected savings**: 300MB-2GB  
**Frequency**: Every 3 months (Jan, Apr, Jul, Oct)

⚠️ **Warning**: Requires re-login to Google accounts

---

## 🎯 Storage Targets

| Status | Free Space | Action Needed |
|--------|-----------|---------------|
| 🟢 **Healthy** | >2GB (>20%) | Keep doing weekly maintenance |
| 🟡 **Stable** | 1.5-2GB (15-20%) | Run monthly cleanup |
| 🟠 **Warning** | 1-1.5GB (10-15%) | Run quarterly cleanup |
| 🔴 **Critical** | <1GB (<10%) | Run quarterly + review apps |

**Current**: 🟡 **Stable** (1.6GB free)

---

## 📊 Quick Storage Check

```bash
# Check current storage
adb shell df -h | grep "/data"

# Detailed breakdown
adb shell dumpsys diskstats | grep "Data-Free"

# List user apps
adb shell pm list packages -3 | wc -l
```

---

## 🔄 After Quarterly Cleanup

You'll need to re-login to these services:

1. **Google Play Store**
   - Open Play Store
   - Menu → Account → Sign in

2. **Gmail** (if installed)
   - Open Gmail → Sign in

3. **Chrome Sync**
   - Open Chrome
   - Menu → Sign in
   - Enable sync

4. **Verify Camera**
   - Open Camera app
   - Take test photo

5. **Test SSH** (if using)
   ```bash
   ssh -p 8022 <your-phone-ip>
   ```

---

## 📝 Manual Cleanup (Optional)

### Review Download Folder
```bash
# List downloads
adb shell ls -lh /sdcard/Download/

# Remove specific file
adb shell rm /sdcard/Download/filename.ext
```

### Find Large Files
```bash
# Files over 10MB
adb shell "find /sdcard -type f -size +10M 2>/dev/null"

# Files over 50MB
adb shell "find /sdcard -type f -size +50M 2>/dev/null"
```

### Clear Specific App Data (Use Carefully!)
```bash
# Clear app cache only (safe, no data loss)
adb shell pm clear <package-name> --cache-only

# Clear all app data (WARNING: loses app settings!)
adb shell pm clear <package-name>
```

---

## 🛡️ Safety Tips

### **Safe Operations** (Do Anytime)
✅ Clear browser caches  
✅ Clear app caches  
✅ Delete temp files  
✅ Delete old downloads  
✅ Clear Google Play Services **cache** only

### **Caution Required** (Review First)
⚠️ Clear Google Play Services **data** (requires re-login)  
⚠️ Clear app **data** (loses settings)  
⚠️ Delete files from DCIM/Pictures  
⚠️ Uninstall apps

### **Never Do** (Can Break Things)
❌ Delete files from /system  
❌ Clear camera app data  
❌ Clear Termux app data (loses all your Linux setup!)  
❌ Disable critical system packages

---

## 📱 Prevention Tips

### Keep Storage Healthy Long-Term

1. **Camera to SD card** ✅ (You already have this!)
   - Photos/videos don't fill internal storage

2. **Regular cleanup schedule**
   - Set calendar reminders:
     - Every Monday: Weekly cleanup
     - Last day of month: Monthly cleanup
     - First day of quarter: Quarterly cleanup

3. **Monitor storage monthly**
   ```bash
   ./scripts/monthly_cleanup.sh
   ```

4. **Review apps quarterly**
   - Uninstall apps you don't use
   - Check for duplicate functionality

5. **Move media to SD card**
   - Use file manager to move photos/videos
   - SD card has 80GB free!

---

## 🚀 Quick Commands

### Weekly Quick Clean
```bash
adb shell pm clear com.android.chrome --cache-only
adb shell pm clear org.mozilla.firefox --cache-only
adb shell "find /sdcard -name '*.tmp' -delete"
```

### Emergency Space Recovery
```bash
# If you're critically low on space
adb shell pm clear com.google.android.gms  # Frees ~1-2GB
# Then re-login to Google
```

### Check What's Using Space
```bash
# App sizes
adb shell dumpsys diskstats | grep "App Size"

# App data
adb shell dumpsys diskstats | grep "App Data"

# Cache
adb shell dumpsys diskstats | grep "Cache"
```

---

## 📊 Expected Results

### With Regular Maintenance

| Timeframe | Free Space | Method |
|-----------|-----------|---------|
| **Week 1** | 1.6GB | Weekly cleanup |
| **Week 2** | 1.55GB | Weekly cleanup |
| **Week 3** | 1.5GB | Weekly cleanup |
| **Week 4** | 1.6GB | Monthly cleanup |
| **Month 2** | 1.5-1.7GB | Weekly + monthly |
| **Month 3** | 1.5-1.7GB | Weekly + monthly |
| **Quarter end** | 2-3GB | Quarterly deep clean |

**Sustainable range**: **1.5-2GB free** with regular maintenance

---

## 🆘 Troubleshooting

### "Storage critically low" warning
1. Run quarterly cleanup immediately
2. Clear Google Play Services data
3. Review and uninstall unused apps
4. Check for large files to move to SD card

### Scripts not working
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Check ADB connection
adb devices

# Reconnect phone
adb kill-server
adb start-server
adb devices
```

### Can't free enough space
- Review installed apps (maybe remove Firefox or Nova?)
- Move all media to SD card
- Consider factory reset (last resort)

---

## 📈 Track Your Progress

Keep a log of your cleanups:

```bash
# Add to end of cleanup scripts
echo "$(date): Cleanup completed, $(adb shell dumpsys diskstats | grep 'Data-Free')" >> ~/cleanup_log.txt
```

---

## 🎯 Your Current Setup

**Apps to Keep**:
- ✅ Termux (essential)
- ✅ Nova Launcher (you use it)
- ✅ Firefox (you use it)
- ✅ Reolink (you need it)
- ✅ DroidCam (you use it)
- ✅ File Manager (you use it)
- ✅ KDE Connect (you use it)

**Current Status**: 1.6GB free (84% used)  
**Target**: Maintain 1.5-2GB free  
**Method**: Weekly + monthly + quarterly cleanup

---

**You're all set!** 🎉

Just run the scripts on schedule and you'll maintain healthy storage levels without having to remove any apps you're using.
