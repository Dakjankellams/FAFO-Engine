#!/data/data/com.termux/files/usr/bin/bash

echo -e "\033[1;33m🛠️  FAFO Global Repair Initiated...\033[0m"
echo "------------------------------------------------"

# 1. FIX NVM & PREFIX CONFLICT
echo "[1/4] Fixing NVM environment conflict..."
# This unsets PREFIX only while NVM loads, then puts it back
if grep -q "nvm" ~/.bashrc; then
    sed -i '/nvm.sh/i unset PREFIX' ~/.bashrc
    sed -i '/nvm.sh/a export PREFIX="/data/data/com.termux/files/usr"' ~/.bashrc
    echo "✅ NVM Prefix bypass added to .bashrc."
fi

# 2. GLOBAL PATH NEUTRALIZER (Absolute to Relative)
echo "[2/4] Converting hardcoded absolute paths to \$HOME variable..."
# This replaces the long Termux string with the internal $HOME variable in all your scripts
# This makes your scripts "portable" so they never break again if you move them.
TARGET_STRING="$HOME"
find "$HOME" -type f \( -name "*.sh" -o -name "*.js" -o -name "*.py" -o -name "*.txt" -o -name "*.json" \) -not -path '*/.*' | xargs sed -i "s|$TARGET_STRING|\$HOME|g" 2>/dev/null
echo "✅ Hardcoded paths neutralized in scripts and configs."

# 3. SYMLINK SURGEON
echo "[3/4] Cleaning up broken symlinks..."
# Remove the specific broken links identified in your log
rm -f "$HOME/storage/podcasts" "$HOME/storage/audiobooks"
find "$HOME" -xtype l -delete
echo "✅ Broken symlinks removed."

# Fix storage links specifically
termux-setup-storage
echo "✅ Storage links refreshed."

# 4. SCRIPT CORRECTIONS
echo "[4/4] Fixing syntax errors in your audit scripts..."
# Fix that '-echo' error in your fafo-audit.sh script
if [ -f "fafo-audit.sh" ]; then
    sed -i 's/-echo/-print/g' fafo-audit.sh
    echo "✅ fafo-audit.sh syntax fixed."
fi

echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ REPAIR COMPLETE!\033[0m"
echo "Please run: 'source ~/.bashrc' to apply changes."
echo "------------------------------------------------"
