#!/data/data/com.termux/files/usr/bin/bash

set -u

AUDIT_LIST="$HOME/files_to_fix.txt"

echo -e "\u001B[1;33m🕵️  Starting Global Audit of $HOME...\u001B[0m"
echo "------------------------------------------------"

# 1. Fix Permissions & Shebangs
echo "[1/4] Fixing Permissions and Termux shebangs..."
find "$HOME" -maxdepth 4 -type f 2>/dev/null | while read -r file; do
    case "$file" in
        *.sh|*.py|*.pl)
            if file "$file" 2>/dev/null | grep -q "script"; then
                chmod +x "$file" 2>/dev/null || true
                termux-fix-shebang "$file" &>/dev/null || true
            fi
            ;;
    esac
done
echo "✅ Permissions & Shebangs synchronized."

# 2. Find Broken Symlinks
echo -e "
[2/4] Searching for broken symlinks..."
broken_links=$(find "$HOME" -xtype l 2>/dev/null || true)
if [ -z "$broken_links" ]; then
    echo "✅ No broken symlinks found."
else
    echo -e "\u001B[1;31m⚠️  Broken links found:\u001B[0m"
    echo "$broken_links"
    echo "💡 Suggestion: Delete them with 'rm' and recreate them."
fi

# 3. Hardcoded Path Audit - EXCLUDE ArchiveSafe + focus on scripts/configs
echo -e "
[3/4] Auditing scripts/configs for hardcoded home paths..."
: > "$AUDIT_LIST"

grep -rIl "$HOME" "$HOME" \
  --exclude="fafo-audit.sh" \
  --exclude-dir=".git" \
  --exclude-dir="venv" \
  --exclude-dir="ArchiveSafe" \
  --include="*.sh" \
  --include="*.py" \
  --include="*.cfg" \
  --include="*.log" \
  2>/dev/null || true | while read -r file; do
    [ -z "$file" ] && continue
    echo -e "\u001B[1;34m🔍 Review needed:\u001B[0m $file"
    echo "   (This file contains a direct path to your home folder.)"
    echo "$file" >> "$AUDIT_LIST"
done

echo "Paths needing review saved to: $AUDIT_LIST"

# 4. Empty Scripts Check
echo -e "
[4/4] Checking for empty scripts..."
find "$HOME" -type f -name "*.sh" -size 0 -print 2>/dev/null \
  | sed 's/^/⚠️  Empty script: /'

echo -e "
------------------------------------------------"
echo -e "\u001B[1;32m✨ Audit Complete!\u001B[0m"
echo "Run: cat $AUDIT_LIST | ~/bin/fix_paths.sh"
