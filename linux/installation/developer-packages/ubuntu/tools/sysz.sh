#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if [[ "$OS" != "linux" ]]; then
    echo "[SKIP] sysz is Linux-only (requires systemd). Skipping on $OS."
    exit 0
fi

if ! command -v sysz &>/dev/null; then
    echo "[INSTALLING ⬇️] sysz"

    sudo curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL \
        https://github.com/joehillen/sysz/releases/latest/download/sysz \
        -o /usr/local/bin/sysz
    sudo chmod +x /usr/local/bin/sysz

    if ! command -v sysz &>/dev/null; then
        echo "[FAIL ❌] sysz installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] sysz command installed!"
else
    echo "[CHECKED ✅] sysz command exists"
fi