# Samsung Galaxy J7 - Storage & Bloatware Report
Generated: 2026-05-21

## 1. Camera Storage Settings ✅

**Current Status:**
- ✅ Photos/Videos are being saved to **SD Card** (not internal storage)
- SD Card location: `/storage/2143-6716/DCIM/Camera/`
- Internal DCIM folder: Empty (no files)

**SD Card Camera Storage:**
- Total size: **14MB** (5 files)
- Recent files:
  - Photos: 20260521_145946.jpg, 20260521_145944.jpg, 20260521_145715.jpg, 20260521_145714.jpg
  - Videos: 20260521_145946.mp4, 20260521_145717.mp4

## 2. Storage Space Usage

**SD Card (External Storage):**
- Total: 119GB
- Used: 38GB (32%)
- Free: 81GB
- Mount: `/storage/2143-6716/`

**Internal Storage:**
- Total: 10GB
- Used: 6.3GB (62%)
- Free: 3.9GB
- Mount: `/storage/emulated/0/`

**Recommendation:** Continue using SD card for photos/videos. You have plenty of space (SD card).

## 3. Additional Bloatware Candidates

### 🗑️ SAFE TO DISABLE - Additional Verizon Apps

**Still enabled (can disable):**
```bash
com.vzw.apnlib                  # Verizon APN Library
com.qualcomm.ltebc_vzw          # Verizon LTE Broadcast
qualcomm.com.vzw_msdc_api       # Verizon MSDC API
com.verizon.obdm_permissions    # Verizon permissions (already tried, may fail)
```

### 🗑️ SAFE TO DISABLE - Samsung Bloatware (Non-Essential)

**Features you likely don't use:**
```bash
com.samsung.android.smartmirroring           # Smart View/Screen Mirroring
com.samsung.advancedcalling                  # Advanced Calling/Video Calling
com.samsung.clipboardsaveservice             # Clipboard history
com.samsung.android.clipboarduiservice       # Clipboard UI
com.samsung.faceservice                      # Face recognition service
com.samsung.android.app.assistantmenu        # Accessibility assistant menu
com.samsung.android.easysetup                # Easy setup wizard
com.samsung.android.app.soundpicker          # Sound picker
com.samsung.carrier.logcollector             # Carrier log collector
com.samsung.InputEventApp                    # Input event logging
```

### ⚠️ DISABLE WITH CAUTION - May Affect Some Features

**Samsung Services (disable if you don't use Samsung account):**
```bash
com.samsung.android.mobileservice            # Samsung account/cloud services
com.samsung.android.coreapps                 # Samsung core apps
com.osp.app.signin                          # Samsung sign-in
```

**Other Samsung Services:**
```bash
com.samsung.android.location                 # Samsung location service (may affect GPS accuracy)
com.samsung.android.timezone.autoupdate_O    # Automatic timezone updates
com.samsung.networkui                        # Network UI (WiFi calling features)
```

### 🛑 DO NOT DISABLE - Keep These

**Already protected (critical for camera):**
- com.samsung.cmh
- com.sec.android.app.camera
- com.samsung.android.providers.context
- com.sec.android.daemonapp
- com.samsung.android.provider.shootingmodeprovider

**System essentials:**
- com.samsung.android.SettingsReceiver
- com.samsung.ucs.agent.boot
- com.samsung.sec.android.application.csc

## 4. Currently Disabled Packages (12 total)

1. ✅ com.verizon.mips.services
2. ✅ com.verizon.obdm
3. ✅ com.verizon.llkagent
4. ✅ com.LogiaGroup.LogiaDeck
5. ✅ com.monotype.android.font.rosemary
6. ✅ com.monotype.android.font.chococooky
7. ✅ com.monotype.android.font.cooljazz
8. ✅ com.sec.android.app.shealth
9. ✅ com.hancom.office.viewer
10. ✅ com.enhance.gameservice
11. ✅ com.customermobile.preload.vzw
12. ✅ com.samsung.upsmtheme

## 5. Recommended Next Steps

**Conservative approach (Recommended):**
Disable 10-15 more clearly safe packages:
- Remaining Verizon bloatware (3 packages)
- Samsung clipboard services (2 packages)
- Samsung Smart View/mirroring (1 package)
- Samsung input logging and carrier log collector (2 packages)
- Samsung Easy Setup (1 package)

**Aggressive approach:**
Disable all non-essential Samsung services (~20 packages)
- Risk: May lose some Samsung-specific features
- Benefit: More free RAM and storage
