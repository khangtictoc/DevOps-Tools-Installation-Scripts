#! /bin/bash

TUFW_CLI_VERION=0.2.4

if ! command -v tufw 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] tufw"
    wget https://github.com/peltho/tufw/releases/download/v${TUFW_CLI_VERION}/tufw_${TUFW_CLI_VERION}_linux_amd64.deb
    sudo dpkg -i tufw_${TUFW_CLI_VERION}_linux_amd64.deb

    echo "[INFO] >>>> Clean Up"
    rm -f tufw_${TUFW_CLI_VERION}_linux_amd64.deb

    if ! command -v tufw &> /dev/null; then
        echo "[FAIL ❌] tufw installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] tufw command installed!"
else
    echo "[CHECKED ✅] tufw command exists"
fi