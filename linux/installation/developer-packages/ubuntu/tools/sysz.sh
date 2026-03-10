#! /bin/bash

if ! command -v sysz 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] sysz"
    sudo wget \
        -O /usr/local/bin/sysz \
        https://github.com/joehillen/sysz/releases/latest/download/sysz
    sudo chmod +x /usr/local/bin/sysz

    if ! command -v sysz &> /dev/null; then
        echo "[FAIL ❌] sysz installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] sysz command installed!"
else
    echo "[CHECKED ✅] sysz command exists"
fi