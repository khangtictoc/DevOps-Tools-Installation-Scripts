#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v nvtop &>/dev/null; then
    echo "[INSTALLING ⬇️] nvtop"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install nvtop
    else
        sudo apt update
        if ! sudo apt install -y nvtop 2>/dev/null; then
            echo "[INFO] nvtop not found in default repo, adding PPA..."
            sudo add-apt-repository -y ppa:quentiumyt/nvtop
            sudo apt update
            sudo apt install -y nvtop
        fi
    fi

    if ! command -v nvtop &>/dev/null; then
        echo "[FAIL ❌] nvtop installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] nvtop command installed!"
else
    echo "[CHECKED ✅] nvtop command exists"
fi