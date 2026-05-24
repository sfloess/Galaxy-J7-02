# 🚀 Termux Quick Start Guide

> **💡 New User?** For a simpler, more modular approach, see [MINIMAL_SETUP_GUIDE.md](MINIMAL_SETUP_GUIDE.md)
> - Start with just the essentials (~100MB)
> - Add Debian Linux if needed (~250MB)
> - Add desktop environment if wanted (~650MB)
>
> This guide covers the **full setup** with all tools at once.

## ✅ Status: Apps Installed!
- ✅ F-Droid installed
- ✅ Termux installed  
- ✅ Setup scripts on phone (/sdcard/Download/)

---

## 📱 STEP 1: First Time Setup in Termux

**On your phone, open the Termux app**, then type or copy-paste these commands:

### 1.1 Copy setup script from Download folder
```bash
cp /sdcard/Download/termux_setup.sh ~
chmod +x ~/termux_setup.sh
```

### 1.2 Run the setup script
```bash
~/termux_setup.sh
```

**What this does:**
- ✅ Updates all packages
- ✅ Installs Python, Node.js, Git, SSH, and 30+ tools
- ✅ Creates project directories
- ✅ Configures bash with aliases
- ✅ Creates utility scripts

**This will take 5-10 minutes. Let it complete!**

---

## 📱 STEP 2: Grant Storage Access

When prompted during setup, **TAP "ALLOW"** to let Termux access your files.

Or run manually:
```bash
termux-setup-storage
```

---

## 📱 STEP 3: Copy Demo Files

After setup completes, copy the demo files:

```bash
mkdir -p ~/projects/demos
cp /sdcard/Download/demo_*.py ~/projects/demos/
cp /sdcard/Download/demo_*.sh ~/projects/demos/
chmod +x ~/projects/demos/*.sh
```

---

## 🎯 STEP 4: Try the Demos!

### Demo 1: Web Server
```bash
cd ~/projects/demos
python demo_hello_world.py
```

Then on your phone, open Firefox and go to:
```
http://localhost:8080
```

You should see a web page served from your phone! Press Ctrl+C to stop.

---

### Demo 2: System Monitor
```bash
cd ~/projects/demos
./demo_system_monitor.sh
```

Watch live system stats! Press Ctrl+C to stop.

---

### Demo 3: File Organizer
```bash
cd ~/projects/demos
python demo_file_organizer.py ~/Downloads
```

See how it would organize your files by type!

---

## 🔧 STEP 5: Useful Commands

### Package Management
```bash
pkg update              # Update package lists
pkg upgrade             # Upgrade all packages
pkg install [name]      # Install a package
pkg list-installed      # Show installed packages
```

### Quick Servers
```bash
# Python web server (in any directory)
python -m http.server 8000

# SSH server (access your phone remotely)
sshd
```

### System Info
```bash
sysinfo                 # Custom system info (after setup)
htop                    # Process viewer
df -h                   # Disk usage
free -h                 # Memory usage
```

### Navigation
```bash
projects                # Go to ~/projects (alias)
scripts                 # Go to ~/scripts (alias)
cd ~/storage/shared     # Internal storage
cd ~/storage/external-1 # SD card
```

---

## 💻 STEP 6: Start Coding!

### Create a Python Project
```bash
cd ~/projects
mkdir hello-python
cd hello-python

# Create a simple script
cat > hello.py << 'EOF'
print("Hello from Termux!")
print("Your phone is a computer!")

import sys
print(f"Python version: {sys.version}")
EOF

# Run it!
python hello.py
```

---

### Create a Node.js Project
```bash
cd ~/projects
mkdir hello-node
cd hello-node

# Create package.json
npm init -y

# Create app.js
cat > app.js << 'EOF'
console.log("Hello from Node.js on Termux!");

const http = require('http');
const server = http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('<h1>Hello from Node.js on your phone!</h1>');
});

server.listen(3000, () => {
    console.log('Server running at http://localhost:3000/');
});
EOF

# Run it!
node app.js
```

Visit `http://localhost:3000` in your browser!

---

## 🌐 STEP 7: Access from Other Devices (SSH)

### Start SSH Server
```bash
# Set a password first (if you haven't)
passwd

# Start SSH server
sshd

# Get your IP address
ifconfig wlan0 | grep "inet "
```

### Connect from your computer
```bash
# On your laptop/desktop:
ssh -p 8022 [your-username]@[phone-ip]

# Example:
ssh -p 8022 u0_a123@192.168.1.100
```

Now you can control your phone from your computer!

---

## 📚 STEP 8: Learn More

### Install More Tools
```bash
pkg install neofetch    # Cool system info
pkg install figlet      # ASCII art text
pkg install nmap        # Network scanner
pkg install sqlite      # Database
pkg install vim         # Text editor
pkg install tmux        # Terminal multiplexer
```

### Try Figlet (ASCII Art)
```bash
figlet "Termux Rocks!"
```

### Try Neofetch (System Info)
```bash
neofetch
```

---

## 🎨 Customization

### Change Font (in Termux app)
Long-press screen → Style → Font

### Change Colors
Long-press screen → Style → Choose a color scheme

### Add More Aliases
```bash
echo 'alias weather="curl wttr.in"' >> ~/.bashrc
source ~/.bashrc
weather
```

---

## 🚨 Troubleshooting

### "Permission denied"
```bash
chmod +x filename.sh
```

### "Package not found"
```bash
pkg update
```

### Can't access files
```bash
termux-setup-storage
# Tap "Allow"
```

### SSH won't start
```bash
pkill sshd  # Kill existing
sshd        # Start new
```

---

## 📊 What You Can Build

### Beginner Projects
- ✅ Personal blog (static HTML)
- ✅ Todo list app
- ✅ Weather checker
- ✅ File organizer
- ✅ Password generator

### Intermediate Projects
- ✅ REST API server
- ✅ Chat bot
- ✅ Web scraper
- ✅ Home automation scripts
- ✅ Network monitor

### Advanced Projects
- ✅ Custom Android automation
- ✅ Machine learning experiments
- ✅ IoT controller
- ✅ Git server
- ✅ VPN server

---

## 🎯 Quick Reference Card

| Command | What it does |
|---------|-------------|
| `pkg update` | Update package lists |
| `pkg install X` | Install package X |
| `python file.py` | Run Python script |
| `node file.js` | Run Node.js script |
| `git clone URL` | Clone a repo |
| `sshd` | Start SSH server |
| `python -m http.server` | Start web server |
| `htop` | System monitor |
| `vim file` | Edit file |
| `cd ~/projects` | Go to projects |

---

## ✅ Summary

You now have:
- ✅ F-Droid (open source app store)
- ✅ Termux (Linux environment)
- ✅ Python, Node.js, Git, SSH
- ✅ 30+ development tools
- ✅ Demo projects
- ✅ Custom scripts and aliases

## 🎉 You're Ready!

Your Samsung J7 is now a **full-featured mini computer**!

**Next Steps:**
1. Open Termux on your phone
2. Run the setup script: `~/termux_setup.sh`
3. Try the demos
4. Start building!

---

**Happy Coding! 🚀**

For more help: https://wiki.termux.com/
