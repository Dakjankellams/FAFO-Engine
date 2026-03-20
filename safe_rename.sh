#!/data/data/com.termux/files/usr/bin/bash

src="$1"
dest="$2"

if [ -z "$src" ] || [ -z "$dest" ]; then
    echo "Usage: safe_rename <oldname> <newname>"
    exit 1
fi

if [ ! -e "$src" ]; then
    echo "[SKIP] $src does not exist"
    exit 1
fi

if [ -e "$dest" ]; then
    echo "[ABORT] $dest already exists"
    exit 1
fi

echo "[RENAME] $src → $dest"
mv -n "$src" "$dest"
