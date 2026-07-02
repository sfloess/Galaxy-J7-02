# ⚠️ CRITICAL WARNINGS - LESSONS LEARNED

## Things That BROKE the Phone (2026-06-29)

### 1. NEVER Uninstall Disabled Packages - DISABLE ONLY ❌

**What I did wrong:**
- Uninstalled 71 disabled packages thinking it would free space
- This broke system dependencies

**What broke:**
- Calendar Storage (crashed constantly)
- ANT Radio Service (crashed)
- Unified Settings Service (crashed)
- Contacts Provider (crashed)

**The fix:**
- Reinstalled packages with: `adb shell cmd package install-existing PACKAGE`
- Then disabled them: `adb shell pm disable-user --user 0 PACKAGE`

**THE RULE:**
```
DISABLE packages = They exist but don't run (safe)
UNINSTALL packages = They're gone, breaks dependencies (DANGEROUS)
```

**Packages that MUST exist (even if disabled):**
- com.google.android.syncadapters.calendar
- com.google.android.syncadapters.contacts
- com.android.providers.contacts
- com.samsung.unifiedsettingservice
- com.dsi.ant.server
- com.dsi.ant.service.socket
- com.dsi.ant.sample.acquirechannels

---

### 2. NEVER Clear Launcher Cache Without Backup ❌

**What I did wrong:**
- Ran `pm clear com.teslacoilsw.launcher --cache-only`
- Thought "cache-only" was safe
- DID NOT backup Nova Launcher settings first

**What broke:**
- Complete loss of home screen layout
- All icons, widgets, folders GONE
- User had to rebuild from scratch

**THE RULE:**
```
BEFORE touching Nova Launcher:
1. Tell user to: Nova Settings → Backup & import settings → Create backup
2. Wait for confirmation
3. THEN proceed with any cache clearing
```

**Alternative fix for icon issues:**
- Just reboot the phone
- Or remove/re-add the specific icon
- DON'T clear entire launcher cache

---

### 3. Always Test Incrementally, Not All-At-Once ❌

**What I did wrong:**
- Uninstalled ALL 71 packages at once
- No testing between batches
- When things broke, didn't know which package caused it

**Better approach:**
1. Test with 10 packages first
2. Reboot phone
3. Check for crashes
4. If okay, do next batch
5. If crashes, identify which package and reinstall

---

## PRE-FLIGHT CHECKLIST

Before ANY risky operation, ask user to confirm:

### ✅ Checklist for Package Operations
- [ ] Are we DISABLING (safe) or UNINSTALLING (risky)?
- [ ] Is this a system package with dependencies?
- [ ] Should we test with 10 packages first?
- [ ] Do we have a way to restore if it breaks?

### ✅ Checklist for Launcher Operations  
- [ ] Has user backed up Nova settings?
- [ ] Can we fix icon issue without clearing cache?
- [ ] Is this really necessary or just cosmetic?

### ✅ Checklist for Storage Cleanup
- [ ] Are we clearing caches only (safe)?
- [ ] Or clearing app data (DANGEROUS - loses settings)?
- [ ] Does user know what will be lost?

---

## Emergency Restore Commands

If things break again:

```bash
# Reinstall critical packages
adb shell cmd package install-existing com.google.android.syncadapters.calendar
adb shell cmd package install-existing com.google.android.syncadapters.contacts
adb shell cmd package install-existing com.android.providers.contacts
adb shell cmd package install-existing com.samsung.unifiedsettingservice
adb shell cmd package install-existing com.dsi.ant.server

# Then disable them (don't uninstall)
adb shell pm disable-user --user 0 PACKAGE_NAME

# Restore Nova backup (on phone)
Nova Settings → Backup & import → Restore backup
```

---

## What I Learned

1. **Measure twice, cut once** - Test small batches first
2. **Always have a backup plan** - Don't do irreversible operations
3. **Warn the user clearly** - Explain what WILL be lost, not just what MIGHT happen
4. **Cache ≠ Safe** - Even "cache-only" operations can destroy user data
5. **System dependencies are hidden** - Just because a package is disabled doesn't mean it's safe to uninstall

---

## Date: 2026-06-29
## User: sfloess  
## Device: Samsung Galaxy J7 (SM-J727V)
## Session: Samsung-J7
