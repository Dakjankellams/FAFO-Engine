#!/bin/bash
# FAFO KALI USERLAND FULL EMERGENCY REBUILD v2.0
# One-command recovery for UserLAnd Kali crashes
set -euo pipefail
echo "🔥 FAFO KALI REBUILD STARTING..."

# BASE SYSTEM + DEV TOOLS
sudo apt-get update -y --fix-missing
sudo apt-get install -y rsync git build-essential checkinstall autoconf automake \
libtool-bin libplist-dev libimobiledevice-1.0-6 libimobiledevice-utils \
libimobiledevice-dev usbmuxd ifuse libssl-dev adb pkg-config cmake \
nano python3 python3-pip python3-venv curl wget zip unzip htop vim lsof \
net-tools iproute2 file manpages-dev

# GIT IDENTITY
git config --global user.name "Dakjankellams"
git config --global user.email "janellvictoria17@gmail.com"

# FAFO DIRECTORIES
mkdir -p ~/fafo-sync/{outbox/{ios,ocr,notes,markdown},logs} ~/fafo-repos

# CLONE FAFO REPO
cd ~/fafo-repos
git clone https://github.com/Dakjankellams/fafo-sync.git || true
cd fafo-sync && mkdir -p ingest/{ios,ocr,notes,markdown}

echo "✅ FULL REBUILD COMPLETE"
echo "Test with: bash ~/verify-dev.sh"
