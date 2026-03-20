#!/data/data/com.termux/files/usr/bin/bash

# Install 'file' utility if not present (needed to identify scripts)
pkg install file termux-exec -y

echo -e "\n🔍 Analyzing files in current directory...\n"

for file in *; do
    # Skip directories and this script itself
    if [ -d "$file" ] || [ "$file" == "fix-scripts.sh" ]; then
        continue
    fi

    echo -e "📄 \033[1;34m$file\033[0m"

    # 1. Make the file executable
    chmod +x "$file"
    echo "   ✅ Permissions fixed (Executable)"

    # 2. Fix Termux Shebang (Crucial for scripts from GitHub/PC)
    termux-fix-shebang "$file" &> /dev/null
    echo "   ✅ Shebang paths fixed for Termux"

    # 3. Detect type and suggest run command
    FILE_TYPE=$(file -b "$file")
    
    if [[ "$FILE_TYPE" == *"Python"* ]]; then
        echo -e "   🚀 Run with: \033[1;32mpython $file\033[0m"
    elif [[ "$FILE_TYPE" == *"Bourne-Again shell"* || "$FILE_TYPE" == *"POSIX shell"* ]]; then
        echo -e "   🚀 Run with: \033[1;32m./$file\033[0m"
    elif [[ "$FILE_TYPE" == *"Node.js"* || "$FILE_TYPE" == *"JavaScript"* ]]; then
        echo -e "   🚀 Run with: \033[1;32mnode $file\033[0m"
    else
        echo -e "   🚀 Type: $FILE_TYPE. Try running with: \033[1;32m./$file\033[0m"
    fi
    echo "---------------------------------------"
done

echo -e "\n✨ Done! Remember: Use \033[1;33m./filename\033[0m to run, not cd."
