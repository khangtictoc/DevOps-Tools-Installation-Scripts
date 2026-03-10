#! /bin/bash

if ! command -v kubectl 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] kubectl"
    # Kubectl - Kubernetes CLI
    curl  -LO "https://dl.k8s.io/release/$(curl  -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    echo "[INFO] >>>> Clean Up"
    rm kubectl

    if ! command -v kubectl &> /dev/null; then
        echo "[FAIL ❌] kubectl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubectl command installed!"
else
    echo "[CHECKED ✅] kubectl command exists"
fi