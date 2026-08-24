#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/get_os.sh")

if ! command -v fd &>/dev/null; then
    echo "[INSTALLING ⬇️] fd"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install fd
    else
        sudo apt-get -y install fd-find
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    fi

    if ! command -v fd &> /dev/null; then
        echo "[FAIL ❌] fd installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] fd command installed!"
else
    echo "[CHECKED ✅] fd command exists"
fi