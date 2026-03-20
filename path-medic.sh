#!/data/data/com.termux/files/usr/bin/bash

# FAFO Path-Medic: Search, Replace, and Repair
# Usage: ./path-medic.sh <old_name> <new_name>

OLD_NAME=$1
NEW_NAME=$2

if [ -z "$OLD_NAME" ] || [ -z "$NEW_NAME" ]; then
    echo -e "\033[1;31mUsage: ./path-medic.sh old_folder_name new_folder_name\033[0m"
    exit 1
fi

echo -e "\033[1;33m🚑 Starting Path-Medic for [$OLD_NAME] -> [$NEW_NAME]...\033[0m"
echo "------------------------------------------------"

# 1. THE SWAPPER: Update text inside all scripts
echo "[1/4] Updating folder references inside scripts..."
# Find all text files, search for the old name, and replace with the new name
grep -rIl "$OLD_NAME" "$HOME" --exclude-dir=".*" --exclude="path-medic.sh" | while read -r file; do
    sed -i "s|$OLD_NAME|$NEW_NAME|g" "$file"
    echo "   ✅ Updated: $(basename "$file")"
done

# 2. THE LINK DOCTOR: Fix broken symlinks
echo -e "\n[2/4] Checking for broken symbolic links..."
find "$HOME" -xtype l | while read -r link; do
    target=$(readlink "$link")
    # If the link is broken because it contains the old name, try to fix it
    if [[ "$target" == *"$OLD_NAME"* ]]; then
        new_target="${target//$OLD_NAME/$NEW_NAME}"
        if [ -e "$new_target" ]; then
            ln -sf "$new_target" "$link"
            echo "   ✅ Repaired Link: $(basename "$link") -> $new_target"
        else
            echo "   ❌ Link $(basename "$link") is broken and target doesn't exist at new path."
        fi
    fi
done

# 3. THE VALIDATOR: Check if scripts mention non-existent files
echo -e "\n[3/4] Validating paths mentioned in scripts..."
grep -rE "$HOME/[a-zA-Z0-9/_.-]+" "$HOME" --exclude-dir=".*" --exclude="path-medic.sh" | while read -r line; do
    # Extract the potential path from the line
    potential_path=$(echo "$line" | grep -oE "$HOME/[a-zA-Z0-9/_.-]+")
    if [ ! -e "$potential_path" ]; then
        file_source=$(echo "$line" | cut -d: -f1)
        echo -e "   \033[1;31m⚠️  Dead Path Found in:\033[0m $(basename "$file_source")"
        echo "      Path: $potential_path (Does not exist!)"
    fi
done

# 4. THE MAINTENANCE: Permissions & Shebangs
echo -e "\n[4/4] Finalizing permissions..."
find "$HOME" -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} +
find "$HOME" -type f \( -name "*.sh" -o -name "*.py" \) -exec termux-fix-shebang {} + &>/dev/null

echo -e "\n------------------------------------------------"
echo -e "\033[1;32m✨ Path-Medic finished!\033[0m"
echo "Your folder references have been updated and validated."
