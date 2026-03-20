#!/data/data/com.termux/files/usr/bin/bash

# FAFO Grand Inspector - The Ultimate Termux Health Check
LOG_FILE="grand_inspection_$(date +%Y%m%d_%H%M).log"
exec > >(tee -i "$LOG_FILE") 2>&1

echo -e "\033[1;35m🔍 FAFO GRAND INSPECTION STARTING...\033[0m"
echo "Report will be saved to: $LOG_FILE"
echo "------------------------------------------------"

# 1. SYSTEM HEALTH CHECK
echo -e "\n[1/6] System Environment Health"
if [[ "$TERMUX_VERSION" == *"googleplay"* ]]; then
    echo -e "⚠️  \033[1;31mCRITICAL:\033[0m You are on the Google Play version of Termux."
    echo "   Packages will eventually stop updating. Move to F-Droid soon."
else
    echo "✅ Termux source looks healthy."
fi

# 2. MISSING BINARY DEPENDENCY SCAN
echo -e "\n[2/6] Scanning scripts for missing app dependencies..."
# Extract common commands used in scripts and check if they exist in $PATH
grep -I --exclude-dir={.git,venv,node_modules,Downloads} -I --exclude-dir={.git,venv,node_modules} -I -rEho "\b(git|curl|wget|python|node|nmap|ffmpeg|grep -I --exclude-dir={.git,venv,node_modules,Downloads} -I --exclude-dir={.git,venv,node_modules}|sed|awk|php|perl)\b" "$HOME" --exclude-dir=".*" --exclude="*.log" | sort -u | while read -r cmd; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "❌ \033[1;31mMISSING:\033[0m '$cmd' is used in your scripts but not installed. Run: pkg install $cmd"
    fi
done

# 3. BASH SYNTAX CHECK
echo -e "\n[3/6] Checking Bash syntax in .sh files..."
find "$HOME" -name "*.sh" -not -path '*/.*' | while read -r script; do
    bash -n "$script" 2> .syntax_err
    if [ -s .syntax_err ]; then
        echo -e "❌ \033[1;31mSyntax Error in:\033[0m $script"
        cat .syntax_err
    fi
done

# 4. PYTHON SYNTAX CHECK
echo -e "\n[4/6] Checking Python syntax in .py files..."
find "$HOME" -name "*.py" -not -path '*/.*' | while read -r script; do
    python -m py_compile "$script" &> .syntax_err
    if [ $? -ne 0 ]; then
        echo -e "❌ \033[1;31mSyntax Error in:\033[0m $script"
        cat .syntax_err
    fi
done

# 5. NODE.JS SYNTAX CHECK
echo -e "\n[5/6] Checking Node.js syntax in .js files..."
find "$HOME" -name "*.js" -not -path '*/.*' | while read -r script; do
    node --check "$script" &> .syntax_err
    if [ $? -ne 0 ]; then
        echo -e "❌ \033[1;31mSyntax Error in:\033[0m $script"
        cat .syntax_err
    fi
done

# 6. ABSOLUTE PATH SEARCH
echo -e "\n[6/6] Finalizing Path Audit..."
# Check if the hardcoded path from your previous log still exists anywhere
ABSOLUTE_PATH="$HOME"
count=$(grep -I --exclude-dir={.git,venv,node_modules,Downloads} -I --exclude-dir={.git,venv,node_modules} -I -r "$ABSOLUTE_PATH" "$HOME" --exclude-dir=".*" --exclude="*.log" | wc -l)
if [ "$count" -gt 0 ]; then
    echo -e "⚠️  \033[1;33mSTILL FOUND:\033[0m $count instances of hardcoded absolute paths."
    echo "   Recommendation: Run ./fafo-repair.sh again."
else
    echo "✅ All paths are relative or using \$HOME variable."
fi

# Cleanup
rm -f .syntax_err

echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ INSPECTION COMPLETE!\033[0m"
echo "Total Issues Logged: $(grep -I --exclude-dir={.git,venv,node_modules,Downloads} -I --exclude-dir={.git,venv,node_modules} -I -E '❌|⚠️' "$LOG_FILE" | wc -l)"
echo "------------------------------------------------"
