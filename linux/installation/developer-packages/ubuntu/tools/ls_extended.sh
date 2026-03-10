#!/usr/bin/env bash

if ! command -v ls_extended &>/dev/null; then
    git clone https://github.com/Chirag-Khandelwal/ls_extended.git

    ( cd ls_extended && ./build.sh )

    sudo cp ls_extended/bin/ls_extended /usr/local/bin

    echo "[INFO] Clean up"
    rm -rf ls_extended

    if ! command -v ls_extended &>/dev/null; then
        echo "[FAIL ❌] ls_extended installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ls_extended command installed!"
else
    echo "[CHECKED ✅] ls_extended command exists"
fi