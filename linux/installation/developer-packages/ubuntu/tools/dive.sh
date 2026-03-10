#! /bin/bash

DIVE_VERSION=$(curl -sL  "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if ! command -v dive 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] dive"
    wget https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb
    sudo dpkg -i dive_${DIVE_VERSION}_linux_amd64.deb
    echo "[INFO] >>>> Clean Up"
    rm -f dive_${DIVE_VERSION}_linux_amd64.deb

    if ! command -v dive &> /dev/null; then
        echo "[FAIL ❌] dive installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] dive command installed!"
else
    echo "[CHECKED ✅] dive command exists"
fi