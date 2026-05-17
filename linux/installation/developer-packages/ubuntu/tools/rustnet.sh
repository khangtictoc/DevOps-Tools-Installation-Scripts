#! /bin/bash

RUSTNET_VERSION="v1.3.0"

if ! command -v rustnet 2>&1 >/dev/null
then
    wget "https://github.com/domcyrus/rustnet/releases/download/${RUSTNET_VERSION}/Rustnet_LinuxDEB_amd64.deb"
    sudo dpkg -i Rustnet_LinuxDEB_amd64.deb
    rm Rustnet_LinuxDEB_amd64.deb

    if ! command -v rustnet &> /dev/null; then
        echo "[FAIL ❌] rustnet installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] rustnet command installed!"
else
    echo "[CHECKED ✅] rustnet command exists"
fi