#!/data/data/com.termux/files/usr/bin/bash

# FAFO Auditor & Path Fixer
# Purpose: Fixes permissions, shebangs, and identifies broken paths after a re-org.

echo -e "\033[1;33m🕵️  Starting Global Audit of $HOME...\033[0m"
echo "------------------------------------------------"

# 1. Fix Permissions & Shebangs (Recursive)
echo "[1/4] Fixing Permissions and Termux Shebangs..."
find "$HOME" -maxdepth 4 -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" -o ! -name "*.*" \) -not -path '*/.*' | while read -r file; do
    if file "$file" | grep -q "script"; then
        chmod +x "$file"
        termux-fix-shebang "$file" &>/dev/null
    fi
done
echo "✅ Permissions & Shebangs synchronized."

# 2. Find Broken Symlinks (Shortcuts that point to nowhere)
echo -e "\n[2/4] Searching for broken symlinks..."
broken_links=$(find "$HOME" -xtype l)
if [ -z "$broken_links" ]; then
    echo "✅ No broken symlinks found."
else
    echo -e "\033[1;31m⚠️  Broken links found (they point to folders you moved):\033[0m"
    echo "$broken_links"
    echo "💡 Suggestion: Delete them with 'rm' and recreate them."
fi

# 3. Hardcoded Path Audit
# This looks for scripts that mention your home directory specifically.
echo -e "\n[3/4] Auditing scripts for hardcoded home paths..."
# We search for the Termux home path string inside files
grep -rIl "$HOME" "$HOME" --exclude="fafo-audit.sh" --exclude-dir=".*" | while read -r file; do
    echo -e "\033[1;34m🔍 Review needed:\033[0m $file"
    echo "   (This file contains a direct path to your home folder. If you moved it, update the path inside.)"
done

# 4. Syntax Safety Check
echo -e "\n[4/4] Checking for empty or corrupted scripts..."
find "$HOME" -type f -name "*.sh" -size 0 -print "⚠️  Empty script found: %p\n"

echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ Audit Complete!\033[0m"
echo "Check the 'Review needed' files above to ensure their paths are correct."
