#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo "--------------------------------------"
    echo "5) 📱 Analyze Facebook Backup Media"
    echo "6) View All Logs"
    echo "7) ⚡ View LATEST FAFO Log"
    echo "8) 🔥 Cleanup All Logs"
    echo "9) 🔧 Auto-Repair Scripts"
    echo "Q) Exit Dashboard"
    echo "--------------------------------------"
    read -p "Select an option: " choice
    case $choice in
        5) python3 ~/analyze_fb.py; read ;;
        6) ls -lh *.log; read ;;
        7) latest=$(ls -t *.log | head -1); [ -f "$latest" ] && cat "$latest" || echo "No logs."; read ;;
        8) rm -v *.log; read ;;
        9)
            echo "🔧 Starting Auto-Repair..."
            sed -i 's/\t/    /g' ~/*.py 2>/dev/null
            sed -i 's/\r//g' ~/*.py ~/*.sh 2>/dev/null
            chmod +x ~/*.sh
            echo "✅ Fixed indentation and line endings."
            read ;;
        q|Q) break ;;
        *) echo "Invalid option."; sleep 1 ;;
    esac
done
