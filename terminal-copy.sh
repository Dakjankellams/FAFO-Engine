#!/data/data/com.termux/files/usr/bin/bash

# Define the output file in your Android Downloads
OUTPUT="/sdcard/Download/termux_capture.txt"

# 1. Capture the entire scrollback buffer from tmux
# -S - tells it to start from the very beginning of history
tmux capture-pane -S - -p > "$OUTPUT"

echo "------------------------------------------"
echo "✅ ALL TERMINAL TEXT CAPTURED!"
echo "Location: Internal Storage > Downloads > termux_capture.txt"
echo "------------------------------------------"
echo "You can now open this file in any Android Notepad."
