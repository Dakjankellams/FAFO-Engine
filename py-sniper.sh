#!/data/data/com.termux/files/usr/bin/bash

echo -e "\033[1;35m🎯 Python Syntax Sniper Starting...\033[0m"

# 1. Locate the file anywhere in Termux
TARGET_FILE="PYTHON_analyze_social_media_nojpg.py"
FILE_PATH=$(find "$HOME" -name "$TARGET_FILE" -print -quit)

if [ -z "$FILE_PATH" ]; then
    echo -e "❌ \033[1;31mCould not find $TARGET_FILE anywhere.\033[0m"
    echo "Check if the name is spelled exactly right (capitalization matters)."
    exit 1
fi

echo -e "📍 Found file at: $FILE_PATH"

# 2. Search for the specific "Unterminated String" pattern
# This looks for lines that start a double quote but don't end it before the closing parenthesis
echo -e "\n🔍 Checking for broken print statements..."
grep -nE "print\(f?\"[^\"]*$" "$FILE_PATH" > .broken_lines

if [ ! -s .broken_lines ]; then
    echo "✅ No simple missing-quote errors found. The error might be more complex."
else
    echo "⚠️  Found potential missing quotes on these lines:"
    cat .broken_lines
    
    # 3. AUTO-FIX: Try to append the missing ") to the end of those lines
    echo -e "\n🔧 Attempting Auto-Fix..."
    # This sed finds lines ending with characters but no closing quote/paren and adds them
    sed -i 's/print(f"[^"]*$/&")/' "$FILE_PATH"
    sed -i 's/print("[^"]*$/&")/' "$FILE_PATH"
    echo "✅ Auto-fix attempted on print statements."
fi

# 4. Final Verification
echo -e "\n🧪 Verifying syntax..."
python -m py_compile "$FILE_PATH" &> .py_err
if [ $? -eq 0 ]; then
    echo -e "\033[1;32m🎉 SUCCESS: $TARGET_FILE syntax is now valid!\033[0m"
else
    echo -e "\033[1;31m❌ Syntax still broken:\033[0m"
    cat .py_err
fi

rm -f .broken_lines .py_err
