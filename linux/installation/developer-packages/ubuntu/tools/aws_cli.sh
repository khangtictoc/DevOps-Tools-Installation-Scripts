#! /bin/bash

ARCH=$(uname -m)


function finalize() {
    if ! command -v aws &> /dev/null; then
        echo "[FAIL ❌] aws installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] aws command installed!"
}

if ! command -v aws 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] AWS CLI   "
    if [ "$ARCH" = "aarch64" ]; then
        wget  "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -O "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        echo "[INFO] >>>> Clean Up"
        rm -f awscliv2.zip && rm -drf aws

        finalize
    fi
    if [ "$ARCH" = "x86_64" ]; then
        wget  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        echo "[INFO] >>>> Clean Up"
        rm -f awscliv2.zip && rm -drf aws

        finalize
    fi
else
    echo "[CHECKED ✅] aws command exists!"
    exit 0
fi
