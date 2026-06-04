# File Manager - Cloud Storage Setup Guide
**All 7 Cloud Services in One App**  
**Date**: 2026-05-26

---

## 📱 **General Steps (All Services)**

**In File Manager app:**

1. Open **File Manager**
2. Tap **☰ Menu** (three lines) or **⋮ More**
3. Find **"Network"** or **"Remote"** or **"Cloud"**
4. Tap **+ Add** or **New Connection**
5. Select connection type
6. Enter details (see below)
7. Tap **Save** or **Connect**

---

## ☁️ **Service 1: Google Drive**

### **Connection Type**: Google Drive (if available)
**OR** use WebDAV (see alternative below)

### **If Direct Google Drive Option:**
1. Select **Google Drive**
2. Tap **Sign in with Google**
3. Choose your Google account
4. Allow permissions
5. Done! ✅

### **Alternative - WebDAV Method:**
Google Drive doesn't officially support WebDAV. Use Google Drive app or keep in File Manager if it has native support.

**Recommendation**: File Manager likely has built-in Google Drive support - just sign in!

---

## 📦 **Service 2: Dropbox**

### **Connection Type**: Dropbox (if available)

### **If Direct Dropbox Option:**
1. Select **Dropbox**
2. Tap **Sign in**
3. Enter Dropbox email and password
4. Allow permissions
5. Done! ✅

### **Alternative - WebDAV Method:**
Dropbox doesn't directly support WebDAV, but File Manager should have native Dropbox integration.

---

## 🔷 **Service 3: OneDrive**

### **Connection Type**: OneDrive (if available)

### **Direct OneDrive:**
1. Select **OneDrive**
2. Tap **Sign in with Microsoft**
3. Enter Microsoft account email
4. Enter password
5. Allow permissions
6. Done! ✅

---

## 📦 **Service 4: Box**

### **Connection Type**: Box (if available)

### **Direct Box:**
1. Select **Box**
2. Tap **Sign in**
3. Enter Box email and password
4. Allow permissions
5. Done! ✅

---

## ☁️ **Service 5: pCloud**

### **Connection Type**: WebDAV ⚠️ (Manual setup required)

### **WebDAV Settings:**
```
Connection Name: pCloud
Protocol: HTTPS / WebDAV
Server: webdav.pcloud.com
Port: 443
Username: [Your pCloud email]
Password: [Your pCloud password]
Path: / (or leave empty)
```

### **Step-by-Step:**
1. Select **WebDAV** or **New Connection**
2. Name: **pCloud**
3. Server: `webdav.pcloud.com`
4. Port: `443`
5. Protocol: **HTTPS**
6. Username: Your pCloud email
7. Password: Your pCloud password
8. Tap **Save** or **Connect**
9. Test by browsing files
10. Done! ✅

---

## 🔒 **Service 6: MEGA**

### **Connection Type**: MEGA (if available) or WebDAV

### **If Direct MEGA Option:**
1. Select **MEGA**
2. Tap **Sign in**
3. Enter MEGA email
4. Enter password
5. Allow permissions
6. Done! ✅

### **Note**: MEGA uses proprietary protocol, so File Manager needs native MEGA support. If not available, you may need MEGA app for authentication first.

---

## 🟡 **Service 7: Yandex Disk**

### **Connection Type**: WebDAV ⚠️ (Requires app-specific password)

### **IMPORTANT - Create App Password First:**
1. Go to: https://passport.yandex.com/profile
2. Click **Security**
3. Scroll to **App passwords**
4. Click **Create app password**
5. Select **Other** or **File Manager**
6. Copy the generated password (save it!)
7. Use this password (NOT your main Yandex password)

### **WebDAV Settings:**
```
Connection Name: Yandex Disk
Protocol: HTTPS / WebDAV
Server: webdav.yandex.com
Port: 443
Username: [Your Yandex email]
Password: [App-specific password - see above!]
Path: / (or leave empty)
```

### **Step-by-Step:**
1. Select **WebDAV** or **New Connection**
2. Name: **Yandex Disk**
3. Server: `webdav.yandex.com`
4. Port: `443`
5. Protocol: **HTTPS**
6. Username: Your Yandex email
7. Password: **App-specific password** (not main password!)
8. Tap **Save** or **Connect**
9. Test by browsing files
10. Done! ✅

---

## ✅ **Quick Reference Table**

| Service | Type | Server | Port | Notes |
|---------|------|--------|------|-------|
| **Google Drive** | Native | - | - | Sign in with Google |
| **Dropbox** | Native | - | - | Sign in with Dropbox |
| **OneDrive** | Native | - | - | Sign in with Microsoft |
| **Box** | Native | - | - | Sign in with Box |
| **pCloud** | WebDAV | webdav.pcloud.com | 443 | Use main password |
| **MEGA** | Native | - | - | May need MEGA app |
| **Yandex** | WebDAV | webdav.yandex.com | 443 | **Needs app password!** |

---

## 📝 **Document Your Connections**

**Save this info** (in password manager or secure note):

```
Cloud Connections Reference
============================

pCloud WebDAV
- Server: webdav.pcloud.com
- Port: 443
- Username: [your-email@example.com]
- Password: [your-password]

Yandex Disk WebDAV
- Server: webdav.yandex.com
- Port: 443
- Username: [your-yandex-email]
- Password: [app-specific-password-here]
- App password created: [date]
- Get from: https://passport.yandex.com/profile

Google Drive
- Account: [your-gmail@gmail.com]

Dropbox
- Account: [your-dropbox-email]

OneDrive
- Account: [your-microsoft-email]

Box
- Account: [your-box-email]

MEGA
- Account: [your-mega-email]
```

**Keep this secure!** Use a password manager like Bitwarden (free, open source).

---

## 🔧 **Troubleshooting**

### **"Can't find Network/Remote option"**
- Look for: ☁️ Cloud, 🌐 Network, 📡 Remote
- Try: Menu → More → Storage → Add Storage
- Try: Settings (in File Manager) → Network

### **"Connection failed" for WebDAV**
**Check:**
- ✅ Server address correct (no typos)
- ✅ Port is 443
- ✅ Protocol is HTTPS (not HTTP)
- ✅ Username is your email
- ✅ Password is correct
- ✅ For Yandex: Using **app password** (not main password!)

### **"Authentication failed"**
- **Google/Dropbox/OneDrive/Box**: Check email and password
- **pCloud**: Use main pCloud password
- **Yandex**: Must use app-specific password (see setup above)
- **MEGA**: Check if File Manager supports MEGA natively

### **"Server not found"**
- Check internet connection
- Try: `webdav.pcloud.com` (not `www.webdav.pcloud.com`)
- Try: `webdav.yandex.com` (not `webdav.yandex.ru`)

---

## 🛡️ **Security Tips**

1. **Enable 2FA** on all cloud accounts
2. **Use app-specific passwords** where required (Yandex)
3. **Don't share File Manager screenshots** (may show credentials)
4. **Document connections securely** (password manager)
5. **Regular password changes** (every 6 months)

---

## 📊 **Connection Priority**

**Reconnect in this order** (easiest first):

1. ✅ **Google Drive** (native, sign in)
2. ✅ **Dropbox** (native, sign in)
3. ✅ **OneDrive** (native, sign in)
4. ✅ **Box** (native, sign in)
5. ⚠️ **pCloud** (WebDAV, needs manual setup)
6. ⚠️ **MEGA** (check if native support, otherwise complex)
7. ⚠️ **Yandex** (WebDAV, needs app password setup)

---

## ⏱️ **Time Estimate**

- **Native connections** (Google, Dropbox, OneDrive, Box): 2 min each = 8 min
- **WebDAV connections** (pCloud): 3 min
- **Yandex** (create app password + setup): 5 min
- **MEGA** (depends on File Manager support): 2-5 min

**Total**: ~20-25 minutes to reconnect all 7 services

---

## 💾 **Backup File Manager After Setup**

**Once all connections are working:**

```bash
# From your computer
adb backup -f filemanager_with_clouds_backup.ab com.alphainventor.filemanager
```

**Keep this backup file safe!** If connections are lost again, you can restore.

---

## 🎯 **Step-by-Step Reconnection**

### **Start Here:**

1. [ ] Open File Manager app
2. [ ] Find Network/Remote/Cloud section
3. [ ] Tap + Add
4. [ ] Follow instructions for each service (see above)
5. [ ] Test each connection (browse a folder)
6. [ ] Document connection details
7. [ ] Create backup when done
8. [ ] Done! ✅

---

## 🆘 **Need Help?**

**If you get stuck:**
- Take a screenshot of the error
- Note which service
- Note what step you're on
- I can help troubleshoot!

**Common issues:**
- Yandex requires app password (not main password)
- WebDAV needs HTTPS, not HTTP
- Port 443 for secure connections
- Some services need native support in File Manager

---

## ✅ **After Reconnecting All 7**

**Create a backup immediately:**

1. All connections working? ✅
2. Test each one (open a folder) ✅
3. Document connection details ✅
4. Save to password manager ✅
5. Create ADB backup ✅
6. **You're protected!** ✅

---

**Created**: 2026-05-26  
**Services**: 7 cloud storage in File Manager  
**Time**: ~25 minutes total
