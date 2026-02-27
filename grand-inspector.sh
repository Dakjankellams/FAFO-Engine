#!/data/data/com.termux/files/usr/bin/bash
#!/data/data/com.termux/files/usr/bin/bash

# FAFO Grand Inspector - Clean & Optimized Version
LOG_FILE="grand_inspection_$(date +%Y%m%d_%H%M).log"
exec > >(tee -i "$LOG_FILE") 2>&1

echo -e "\033[1;35m🔍 FAFO GRAND INSPECTION STARTING...\033[0m"
echo "Report will be saved to: $LOG_FILE"
echo "------------------------------------------------"

# 1. SYSTEM HEALTH CHECK
echo -e "\n[1/6] System Environment Health"
if [[ "$TERMUX_VERSION" == *"googleplay"* ]]; then
    echo -e "⚠️  \033[1;31mCRITICAL:\033[0m You are on the Google Play version of Termux."
else
    echo "✅ Termux source looks healthy."
fi

# 2. MISSING BINARY DEPENDENCY SCAN
echo -e "\n[2/6] Scanning scripts for missing app dependencies..."
grep -rI Eho "\b(git|curl|wget|python|node|nmap|ffmpeg|grep|sed|awk|php|perl)\b" "$HOME" \
--exclude-dir=".*" --exclude-dir="Downloads" | sort -u | while read -r cmd; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "❌ \033[1;31mMISSING:\033[0m '$cmd' is used but not installed."
    fi
done

# 3. SYNTAX CHECKS (.sh, .py, .js)
echo -e "\n[3-5/6] Checking Syntax (Skipping Archives & Libraries)..."

# Optimized find: Skips junk folders and looks for scripts
find "$HOME" \( -name "ArchiveSafe" -o -name "node_modules" -o -name "storage" -o -name ".*" \) -prune -o -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" \) -print | while read -r script; do
    case "$script" in
        *.sh)
            bash -n "$script" 2> .syntax_err
            [[ -s .syntax_err ]] && echo -e "❌ Bash Error: $script" && cat .syntax_err ;;
        *.py)
            python -m py_compile "$script" &> .syntax_err
            [[ $? -ne 0 ]] && echo -e "❌ Python Error: $script" && cat .syntax_err ;;
        *.js)
            node --check "$script" &> .syntax_err
            [[ $? -ne 0 ]] && echo -e "❌ Node Error: $script" && cat .syntax_err ;;
    esac
done

# 6. ABSOLUTE PATH SEARCH
echo -e "\n[6/6] Finalizing Path Audit..."
ABSOLUTE_PATH="$HOME"
count=$(grep -r --exclude-dir=".*" --exclude-dir="Downloads" | wc -l)
if [ "$count" -gt 0 ]; then
    echo -e "⚠️  \033[1;33mSTILL FOUND:\033[0m $count hardcoded paths."
else
    echo "✅ All paths are neutralized."
fi

# Cleanup & Export
rm -f .syntax_err
cp "$LOG_FILE" /sdcard/Download/
echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ INSPECTION COMPLETE!\033[0m"
echo "------------------------------------------------"
