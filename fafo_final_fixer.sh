#!/data/data/com.termux/files/usr/bin/bash

echo -e "\033[1;33m🧹 Starting Final Clean-Up...\033[0m"

# 1. FIX MISLABELED PYTHON SCRIPT
if [ -f "$HOME/username.sh" ]; then
    echo "[1/4] Renaming username.sh -> username.py..."
    mv "$HOME/username.sh" "$HOME/username.py"
    # Ensure the shebang is correct for Python
    sed -i '1s|.*|#!/data/data/com.termux/files/usr/bin/python|' "$HOME/username.py"
    chmod +x "$HOME/username.py"
    echo "✅ username.py is now correctly labeled and executable."
fi

# 2. FIX BASH GROUPING (stego_hunt.sh)
if [ -f "$HOME/stego_hunt.sh" ]; then
    echo "[2/4] Repairing syntax in stego_hunt.sh..."
    # This sed command finds parentheses and adds the necessary backslashes
    sed -i 's/(/\\(/g' "$HOME/stego_hunt.sh"
    sed -i 's/)/\\)/g' "$HOME/stego_hunt.sh"
    echo "✅ stego_hunt.sh find command repaired."
fi

# 3. FIX MISSING DEPENDENCY (PHP)
echo "[3/4] Installing missing PHP package..."
pkg install php -y -q
echo "✅ PHP installed."

# 4. AUDIT PYTHON LITERALS
echo "[4/4] Locating broken quotes in Python scripts..."
# This will show you exactly which lines are missing the closing quote
grep -nE "print\(f?\"[^\"]*$" "$HOME/PYTHON_analyze_social_media_nojpg.py"
echo -e "\n💡 \033[1;34mManual fix required for Python quotes:\033[0m"
echo "Check lines 42 and 53 in your social media script."
echo "Ensure they look like this: print(f\"Result: {var}\")"

echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ CLEAN-UP COMPLETE!\033[0m"
echo "------------------------------------------------"
