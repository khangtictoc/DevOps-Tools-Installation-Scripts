#!/usr/bin/env bash

rc_file=$(curl -sS https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/get_shell_startup_filename.sh | bash)

if command -v apt >/dev/null 2>&1; then
    echo "[CHECKED ✅] apt found."
    sudo apt update
    sudo apt install -y git
else
    echo "[WARNING ⚠️] This is not an Ubuntu-based system. No 'apt' found!"
fi

FZF_DIR="$HOME/.fzf"

if [[ ! -d "$FZF_DIR" ]] || [[ -z "$(ls -A "$FZF_DIR" 2>/dev/null)" ]]; then
    echo "Installing fzf..."
    rm -rf "$FZF_DIR"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
else
    echo "fzf already exists — skipping clone."
fi

~/.fzf/install << EOF
y
y
y
EOF

# Check RC file existence
if [[ ! -f "$rc_file" ]]; then
    echo "$rc_file not found!"
    exit 1
fi

# Detect sed type
isGNUsed=false
isBSDsed=false

if sed --version >/dev/null 2>&1; then
    isGNUsed=true
fi

if ! sed --version >/dev/null 2>&1; then
    isBSDsed=true
fi

# Apply sed command based on sed type
if [[ "$isGNUsed" == true ]]; then
    sed -i '/^plugins=(/ s/)/ fzf)/' "$rc_file"
fi

if [[ "$isBSDsed" == true ]]; then
    sed -i '' '/^plugins=(/ s/)/ fzf)/' "$rc_file"
fi

echo "Updated $rc_file successfully ✅"