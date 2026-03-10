#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "[SKIP] sysz is Linux-only (requires systemd). Skipping on $(uname -s)."
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