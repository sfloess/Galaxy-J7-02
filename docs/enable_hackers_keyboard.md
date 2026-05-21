# Enable Hacker's Keyboard on Your Phone

Since F-Droid is already installed, the easiest way is to install Hacker's Keyboard from the F-Droid app.

## Method 1: Install via F-Droid App (Recommended)

**On your phone:**

1. **Open F-Droid app**

2. **Search for "Hacker's Keyboard"**
   - Tap the search icon (magnifying glass)
   - Type: "hacker's keyboard"

3. **Install**
   - Tap on "Hacker's Keyboard" (by Klaus Weidner)
   - Tap "Install"
   - Wait for download and installation

4. **Enable the keyboard:**
   - Go to **Settings → System → Languages & input → Virtual keyboard**
   - Tap **"Manage keyboards"**
   - Enable **"Hacker's Keyboard"**

5. **Set as default keyboard:**
   - Go to **Settings → System → Languages & input**
   - Tap **"Default keyboard"** or **"Current Keyboard"**
   - Select **"Hacker's Keyboard"**

## Method 2: Manual Install via ADB (If F-Droid fails)

I can try downloading from alternative sources and installing via ADB:

```bash
# I'll find a working download link and install it
adb install hackerskeyboard.apk
```

## Features You'll Get

Once installed, Hacker's Keyboard provides:

- ✅ **Full 5-row keyboard** with number row
- ✅ **Ctrl, Alt, Esc, Tab keys** (essential for Termux!)
- ✅ **Arrow keys** for navigation
- ✅ **Function keys** (F1-F12)
- ✅ **Special symbols** for coding (|, ~, <, >, {, }, etc.)
- ✅ **Landscape mode** with extra keys
- ✅ **Customizable layouts**

## Perfect for Termux!

Common keyboard shortcuts in Termux:
- `Ctrl + C` - Stop running program
- `Ctrl + D` - Exit shell
- `Ctrl + Z` - Suspend process
- `Ctrl + L` - Clear screen
- `Tab` - Auto-complete
- `Arrow keys` - Navigate command history
- `Ctrl + A` - Beginning of line
- `Ctrl + E` - End of line

## Configuration Tips

After installation, you can configure:

1. **Long-press settings:**
   - Open Hacker's Keyboard
   - Long-press the space bar
   - Tap "Settings"

2. **Recommended settings:**
   - Enable "Full 5-row layout"
   - Enable "Ctrl/Alt/Meta keys"
   - Adjust key height for comfort
   - Enable "Persistent notification" (keeps keyboard in memory)

## Troubleshooting

**Keyboard not showing up:**
- Restart your phone
- Check Settings → Languages & input → Manage keyboards

**Can't find in F-Droid:**
- Make sure F-Droid has updated its repository list
- In F-Droid: Settings → Repositories → F-Droid → Update

**Want to switch between keyboards:**
- When keyboard is open, swipe down notification bar
- Tap "Change keyboard"
- Select desired keyboard

---

**Package name:** `org.pocketworkstation.pckeyboard`
**F-Droid link:** https://f-droid.org/packages/org.pocketworkstation.pckeyboard/
