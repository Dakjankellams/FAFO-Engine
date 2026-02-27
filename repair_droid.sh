#!/data/data/com.termux/files/usr/bin/bash
# Android-based Termux Toolset for HP dm1 Forensic Prep
# Usage: nano termux_setup.sh (paste content) > Ctrl+O > Ctrl+X
# chmod +x termux_setup.sh
# ./termux_setup.sh
pkg update && pkg upgrade -y
pkg install nmap openssh binutils -y
echo "Tools installed. Use nmap to scan the HP dm1 local IP for open management ports."
