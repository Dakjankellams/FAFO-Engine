#!/bin/bash
# Clear screen for a fresh start
clear

# VISUAL MENU SECTION
echo "--------------------------------------"
echo "5) 📱 Analyze Facebook Backup Media"
echo "6) View All Logs"
echo "7) ⚡ View LATEST FAFO Log"
echo "8) 🔥 Cleanup All Logs"
echo "Q) Exit Dashboard"
echo "--------------------------------------"

# INPUT SECTION
read -p "Select an option: " choice

# ACTION LOGIC SECTION
case $choice in
    7)
        echo "Opening latest log..."
        # Add your command here, e.g., tail -f latest.log
        ;;
    8)
        echo "🔥 Cleaning up logs..."
        # Add your command here, e.g., rm *.log
        ;;
    q|Q)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Press Enter to continue."
        read
        ;;
esac
