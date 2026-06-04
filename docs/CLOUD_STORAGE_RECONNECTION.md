# Cloud Storage Reconnection Guide
**Lost Services**: 7 cloud storage connections  
**Date**: 2026-05-26  
**Services**: Google Drive, Dropbox, OneDrive, Box, pCloud, MEGA, Yandex

---

## 🎯 Two Options to Reconnect

### **Option A: Official Apps (Recommended)** ✅

Install each cloud service's official app - more reliable and feature-rich.

### **Option B: File Manager Reconnection** ⚠️

Reconnect all services in File Manager - convenient but less stable.

---

## 📱 **OPTION A: Official Apps (RECOMMENDED)**

### **1. Google Drive** ☁️

**Install:**
- Play Store → Search "Google Drive"
- Or: Already pre-installed on most phones

**Setup:**
1. Open **Google Drive** app
2. Sign in with your Gmail account
3. Done! Files accessible

**Package**: `com.google.android.apps.docs`

---

### **2. Dropbox** 📦

**Install:**
- Play Store → Search "Dropbox"
- Or F-Droid alternative: Available

**Setup:**
1. Open **Dropbox** app
2. Sign in with Dropbox account
3. Done! Files accessible

**Package**: `com.dropbox.android`

**Install via ADB:**
```bash
# Download APK first, then:
adb install dropbox.apk
```

---

### **3. OneDrive** 🔷

**Install:**
- Play Store → Search "Microsoft OneDrive"

**Setup:**
1. Open **OneDrive** app
2. Sign in with Microsoft account (Outlook/Hotmail)
3. Done! Files accessible

**Package**: `com.microsoft.skydrive`

**Install via ADB:**
```bash
adb install onedrive.apk
```

---

### **4. Box** 📦

**Install:**
- Play Store → Search "Box"

**Setup:**
1. Open **Box** app
2. Sign in with Box account
3. Done! Files accessible

**Package**: `com.box.android`

**Install via ADB:**
```bash
adb install box.apk
```

---

### **5. pCloud** ☁️

**Install:**
- Play Store → Search "pCloud"

**Setup:**
1. Open **pCloud** app
2. Sign in with pCloud account
3. Done! Files accessible

**Package**: `com.pcloud.pcloud`

**Install via ADB:**
```bash
adb install pcloud.apk
```

---

### **6. MEGA** 🔒

**Install:**
- Play Store → Search "MEGA"
- Or F-Droid: Available

**Setup:**
1. Open **MEGA** app
2. Sign in with MEGA account
3. Done! Files accessible

**Package**: `mega.privacy.android.app`

**Install via ADB:**
```bash
adb install mega.apk
```

---

### **7. Yandex Disk** 🟡

**Install:**
- Play Store → Search "Yandex Disk"

**Setup:**
1. Open **Yandex Disk** app
2. Sign in with Yandex account
3. Done! Files accessible

**Package**: `ru.yandex.disk`

**Install via ADB:**
```bash
adb install yandex-disk.apk
```

---

## 🚀 **Quick Install All (Play Store)**

**On your phone:**

1. Open **Play Store**

2. Search and install each:
   - "Google Drive" (might be pre-installed)
   - "Dropbox"
   - "Microsoft OneDrive"
   - "Box"
   - "pCloud"
   - "MEGA"
   - "Yandex Disk"

3. Sign into each app with your account

4. **Done!** All clouds reconnected

**Estimated time**: 15-20 minutes

---

## 📂 **OPTION B: File Manager Reconnection**

If you prefer to keep everything in File Manager:

### **In File Manager App:**

1. Open **File Manager**

2. Tap **☰ Menu** (three lines) or **⋮ More**

3. Find **"Network"**, **"Remote"**, or **"Cloud"** section

4. Tap **+ Add** or **New Connection**

5. **For Each Cloud Service:**

#### **Google Drive:**
- Type: **Google Drive** (if available)
- Sign in with Google account
- Or use **WebDAV** method (see below)

#### **Dropbox:**
- Type: **Dropbox** (if available)
- Sign in with Dropbox account
- Or use **WebDAV** method

#### **OneDrive:**
- Type: **OneDrive** (if available)
- Sign in with Microsoft account

#### **Box:**
- Type: **Box** (if available)
- Sign in with Box account

#### **pCloud:**
- Type: **WebDAV**
- Server: `webdav.pcloud.com`
- Username: Your pCloud email
- Password: Your pCloud password
- Port: `443`
- Protocol: `HTTPS`

#### **MEGA:**
- May need MEGA app for authentication
- Then link to File Manager

#### **Yandex Disk:**
- Type: **WebDAV**
- Server: `webdav.yandex.com`
- Username: Your Yandex email
- Password: App-specific password (not main password)
- Port: `443`
- Protocol: `HTTPS`

---

## ⚠️ **Important Notes**

### **For WebDAV Connections:**

Some services require **app-specific passwords**:

**Yandex:**
1. Go to: https://passport.yandex.com/profile
2. Security → App passwords
3. Create new app password for "File Manager"
4. Use that password (not your main password)

**Google Drive via WebDAV:**
- Not directly supported
- Use official Google Drive app instead

---

## 🔐 **Security Recommendations**

### **Use Official Apps Because:**

1. **OAuth Authentication** - More secure (no password stored)
2. **2FA Support** - Two-factor authentication works
3. **App-Specific Passwords** - Better security model
4. **Automatic Updates** - Security patches
5. **Official Support** - Help if issues arise

### **If Using File Manager:**

1. **Use app-specific passwords** where available
2. **Enable 2FA** on all cloud accounts
3. **Document connections** (see below)
4. **Regular backups** of File Manager data

---

## 📝 **Document Your Connections**

**Create a secure note** (encrypted file or password manager):

```
Cloud Storage Accounts
======================

Google Drive
- Email: youremail@gmail.com
- Notes: Personal files

Dropbox
- Email: youremail@dropbox.com
- Notes: Work documents

OneDrive
- Email: youremail@outlook.com
- Notes: Office files

Box
- Email: youremail@box.com
- Notes: Shared files

pCloud
- Email: youremail@pcloud.com
- WebDAV: webdav.pcloud.com:443
- Notes: Photo backup

MEGA
- Email: youremail@mega.nz
- Notes: Encrypted storage

Yandex Disk
- Email: youremail@yandex.com
- WebDAV: webdav.yandex.com:443
- Notes: Russian cloud storage
- Needs: App-specific password
```

**Keep this secure!** (Password manager like Bitwarden/1Password recommended)

---

## 🎯 **Recommended Approach**

### **Best Setup:**

1. **Install official apps** for all 7 services
2. **Sign in to each** with your accounts
3. **Access via each app** individually
4. **Unified access**: Use Files app or File Manager to see all at once

### **Hybrid Approach:**

- **Official apps**: Google Drive, Dropbox, OneDrive (most used)
- **File Manager WebDAV**: pCloud, MEGA, Yandex (less used)
- **Best of both worlds!**

---

## 📊 **Storage Space Impact**

**Official Apps Install Sizes:**

| App | Size | Notes |
|-----|------|-------|
| Google Drive | ~50MB | Might be pre-installed |
| Dropbox | ~80MB | |
| OneDrive | ~60MB | |
| Box | ~40MB | |
| pCloud | ~30MB | |
| MEGA | ~50MB | |
| Yandex Disk | ~40MB | |
| **Total** | **~350MB** | For all 7 apps |

**You have 3.9GB free** - plenty of room! ✅

---

## 🆘 **Help with Installation**

### **Install via Play Store (Easy):**
Just search each app name and tap Install.

### **Install via ADB (If Play Store issues):**

I can help you download APKs and install via:
```bash
adb install app-name.apk
```

### **Install via F-Droid (Open Source):**
Some apps available on F-Droid:
- MEGA
- Nextcloud (if you want to add it)

---

## ✅ **After Reconnecting - Create Backup**

### **Backup File Manager Data:**
```bash
# From computer
adb backup -f filemanager_backup_$(date +%Y%m%d).ab com.alphainventor.filemanager
```

### **Backup Official Apps:**
Enable backup in Android:
- Settings → Google → Backup
- Make sure "Back up to Google Drive" is ON
- Apps will auto-restore if you reinstall

---

## 🔄 **Migration Path**

### **Current → Better Setup:**

**Now:**
- All in File Manager (lost when cache cleared)

**Better:**
- Official apps for each service
- More reliable, won't lose connections
- Better features (offline, sync, sharing)

**Migration Time:**
- 15-20 minutes to install all 7 apps
- Sign in to each (have passwords ready!)
- Done!

---

## 📱 **Quick Start Commands**

### **Check What's Already Installed:**
```bash
adb shell pm list packages | grep -iE "drive|dropbox|onedrive|box|pcloud|mega|yandex"
```

### **Install Missing Apps:**
Use Play Store or:
```bash
# Example for Dropbox
adb install dropbox.apk
```

---

## 🎯 **Action Plan**

**Choose your path:**

### **Path A: Official Apps (20 min setup, most reliable)**
1. [ ] Install Google Drive app
2. [ ] Install Dropbox app
3. [ ] Install OneDrive app
4. [ ] Install Box app
5. [ ] Install pCloud app
6. [ ] Install MEGA app
7. [ ] Install Yandex Disk app
8. [ ] Sign in to each
9. [ ] Test access
10. [ ] Done! ✅

### **Path B: File Manager Only (10 min setup, less reliable)**
1. [ ] Open File Manager
2. [ ] Add Google Drive connection
3. [ ] Add Dropbox connection
4. [ ] Add OneDrive connection
5. [ ] Add Box connection
6. [ ] Add pCloud WebDAV
7. [ ] Add MEGA connection
8. [ ] Add Yandex WebDAV
9. [ ] Test each
10. [ ] Document connections
11. [ ] Done! ✅

### **Path C: Hybrid (15 min, balanced)**
1. [ ] Install top 3 apps (Drive, Dropbox, OneDrive)
2. [ ] Add pCloud, MEGA, Yandex to File Manager
3. [ ] Best of both worlds! ✅

---

## 💡 **My Recommendation**

**Install official apps for all 7 services.**

**Why:**
- ✅ One-time 20-minute setup
- ✅ Never lose connections again
- ✅ Better features and sync
- ✅ Worth the 350MB storage (you have 3.9GB free!)
- ✅ Professional, reliable solution

**You have the space, and it's the most reliable approach!**

---

## 🆘 **Need Help?**

**I can assist with:**
- Downloading APK files for you
- Installing via ADB
- Troubleshooting login issues
- Setting up WebDAV connections
- Creating app-specific passwords
- Anything else!

**Just ask!**

---

**Created**: 2026-05-26  
**Services**: 7 cloud storage providers  
**Recommended**: Official apps (Path A)
