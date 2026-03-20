\#!/data/data/com.termux/files/usr/bin/bash

# Termux Medic - Auto-Troubleshooter
# This script attempts to fix common environment and package manager errors.

echo "🚑 Starting Termux Medic..."
sleep 1

# 1. Fix Storage Permissions
echo -e "\n[1/5] Checking Storage Permissions..."
if [ ! -d "$HOME/storage" ]; then
    echo "(!) Storage not linked. Requesting permission..."
    termux-setup-storage
else
    echo "✅ Storage is already linked."
fi

# 2. Fix Broken Package Database
echo -e "\n[2/5] Repairing Package Database..."
# Forces dpkg to finish any interrupted configurations
dpkg --configure -a 
# Attempts to fix broken dependencies
apt install -f -y
echo "✅ Database repair commands issued."

# 3. Clear Corrupted Cache
echo -e "\n[3/5] Cleaning Package Cache..."
apt clean
apt autoclean
echo "✅ Cache cleared."

# 4. Update Keyring & Repositories
# Often 'Repository under maintenance' is just an old keyring
echo -e "\n[4/5] Updating Keyrings and Mirrors..."
pkg install termux-keyring -y
echo "Checking connectivity to mirrors..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    apt update
    echo "✅ Repositories refreshed."
else
    echo "❌ No internet connection. Skipping update."
fi

# 5. Check for 'Nuclear' Environment Issues
echo -e "\n[5/5] Environment Health Check..."
if [ -f "$HOME/.bashrc" ]; then
    echo "✅ .bashrc found."
else
    echo "⚠️ .bashrc missing. Creating a default one..."
    echo "PS1='\$ '" > "$HOME/.bashrc"
fi

echo -e "\n======================================="
echo "🛠️  Basic repairs finished."
echo "If you still have '404 Not Found' errors, run:"
echo -e "   ${YELLOW}termux-change-repo${NC}"
echo "and select a different mirror (e.g., Albatross or Grimler)."
echo "======================================="
