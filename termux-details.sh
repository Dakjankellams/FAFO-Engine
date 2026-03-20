#!/data/data/com.termux/files/usr/bin/bash
LOG_FILE="report_$(date +%Y%m%d_%H%M).txt"
exec > >(tee "$LOG_FILE") 2>&1
exec > >(tee termux_report.txt) 2>&1

# Termux Detailer Script
# This script collects comprehensive information about your Termux environment.

# Colors for better readability
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}===============================================${NC}"
echo -e "${YELLOW}           TERMUX SYSTEM ENVIRONMENT           ${NC}"
echo -e "${YELLOW}===============================================${NC}"

# 1. Core System Info (using the built-in termux-info)
echo -e "\n${BLUE}[1] Core System Information${NC}"
termux-info

# 2. Environment Variables
echo -e "\n${BLUE}[2] Critical Environment Paths${NC}"
echo -e "${GREEN}HOME:${NC} $HOME"
echo -e "${GREEN}PREFIX:${NC} $PREFIX"
echo -e "${GREEN}PATH:${NC} $PATH"
echo -e "${GREEN}SHELL:${NC} $SHELL"
echo -e "${GREEN}TERMUXVERSION:${NC} $(getprop ro.com.google.clientidbase)"

# 3. Storage and Filesystem
echo -e "\n${BLUE}[3] Storage Usage${NC}"
df -h | grep -E 'Filesystem|emulated|data'

# 4. Network Configuration
echo -e "\n${BLUE}[4] Network Info${NC}"
echo -e "${GREEN}Local IP Addresses:${NC}"
ip -4 addr show | grep inet | awk '{print $2}'

# 5. Installed Packages Summary
echo -e "\n${BLUE}[5] Package Statistics${NC}"
INSTALLED_COUNT=$(pkg list-installed | wc -l)
echo -e "${GREEN}Total Packages Installed:${NC} $INSTALLED_COUNT"
echo -e "${GREEN}Top 10 Largest Packages:${NC}"
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 10

# 6. Hardware/API Status (Requires termux-api if installed)
if command -v termux-battery-status &> /dev/null; then
    echo -e "\n${BLUE}[6] Battery Status${NC}"
    termux-battery-status
else
    echo -e "\n${BLUE}[6] API Status${NC}"
    echo "termux-api not installed. Install it with 'pkg install termux-api' for hardware details."
fi

# 7. Available Binaries (Commands you can run)
echo -e "\n${BLUE}[7] Commands Preview (First 20 available in bin)${NC}"
ls $PREFIX/bin | head -n 20
echo "..."

echo -e "\n${YELLOW}===============================================${NC}"
echo -e "${YELLOW}                REPORT COMPLETE                ${NC}"
echo -e "${YELLOW}===============================================${NC}"
