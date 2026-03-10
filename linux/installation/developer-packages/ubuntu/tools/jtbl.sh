#! /bin/bash

JTBL_VERSION=1.6.0

if ! command -v jtbl 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] jtbl"
    wget "https://github.com/kellyjonbrazil/jtbl/releases/download/v${JTBL_VERSION}/jtbl-${JTBL_VERSION}-linux-x86_64.tar.gz"
    tar -xzf jtbl-${JTBL_VERSION}-linux-x86_64.tar.gz
    sudo mv jtbl /usr/local/bin/jtbl

    echo "[INFO] >>>> Clean Up"
    rm -f jtbl-${JTBL_VERSION}-linux-x86_64.tar.gz

    if ! command -v jtbl &> /dev/null; then
        echo "[FAIL ❌] jtbl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] jtbl command installed!"
else
    echo "[CHECKED ✅] jtbl command exists"
fi