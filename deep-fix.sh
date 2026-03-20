#!/data/data/com.termux/files/usr/bin/bash

# Global Script Fixer
# Scans $HOME for .sh, .js, .py, and extensionless scripts.

# 1. Install necessary tools silently
echo "Checking dependencies..."
pkg install file termux-exec -y -q

echo -e "\n\033[1;33m🚀 Starting Deep Scan of $HOME...\033[0m"
echo "------------------------------------------------"

# 2. Use 'find' to locate all files (excluding hidden directories like .git)
# We search for .sh, .py, .js OR files with no dot in the name (unknowns)
find "${1:-$HOME}" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" -o ! -name "*.*" \) -not -path '*/.*' | while read -r file; do

    # Skip specific system/config files that shouldn't be touched
    filename=$(basename "$file")
    if [[ "$filename" == "bash_history" || "$filename" == "fix-scripts.sh" ]]; then
        continue
    fi

    # Identify the file type using the 'file' command
    ftype=$(file -b "$file")
    
    # Process only if it is a script or a known extension
    if [[ "$file" == *.sh || "$file" == *.py || "$file" == *.js || "$ftype" == *"script"* ]]; then
        
        echo -e "\033[1;34mFound:\033[0m $file"
        
        # Make Executable
        chmod +x "$file"
        
        # Fix Termux Shebang (Critical for scripts moved from PC/GitHub)
        termux-fix-shebang "$file" &> /dev/null
        
        # Report back with instructions
        if [[ "$file" == *.py || "$ftype" == *"Python"* ]]; then
            echo -e "   ✅ Fixed. Run: \033[1;32mpython \"$file\"\033[0m"
        elif [[ "$file" == *.js || "$ftype" == *"Node"* ]]; then
            echo -e "   ✅ Fixed. Run: \033[1;32mnode \"$file\"\033[0m"
        else
            # For .sh or extensionless scripts
            echo -e "   ✅ Fixed. Run: \033[1;32m\"$file\"\033[0m"
        fi
        echo "------------------------------------------------"
    fi
done

echo -e "\n\033[1;32m✨ Scan Complete!\033[0m"
echo "All scripts have been made executable and had their paths corrected."
