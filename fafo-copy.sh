#!/data/data/com.termux/files/usr/bin/bash

# 1. Create a unique timestamp (Year-Month-Day_Hour-Minute-Second)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 2. Define the output file with the timestamp in the name
OUTPUT="/sdcard/Download/termux_capture_${TIMESTAMP}.txt"

# 3. Check if we are inside tmux
if [ -z "$TMUX" ]; then
    echo "❌ Error: You are not in a tmux session."
    echo "Please restart Termux or type 'tmux' to start recording."
    exit 1
fi

# 4. Capture the entire scrollback buffer
# -S - tells it to grab everything from the very start of the session
tmux capture-pane -S - -p > "$OUTPUT"

echo "------------------------------------------------"
echo "✅ SNAPSHOT SAVED"
echo "Filename: termux_capture_${TIMESTAMP}.txt"
echo "Location: Internal Storage > Downloads"
echo "------------------------------------------------"
