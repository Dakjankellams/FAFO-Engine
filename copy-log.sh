#!/data/data/com.termux/files/usr/bin/bash
if [ -f "session_log.txt" ]; then
    # Remove terminal escape codes (the weird symbols) before copying
    sed "s/\x1B\[[0-9;]*[a-zA-Z]//g" session_log.txt | termux-clipboard-set
    echo "✅ Entire session log copied to clipboard!"
else
    echo "❌ No log file found. Run ./start-log.sh first."
fi
