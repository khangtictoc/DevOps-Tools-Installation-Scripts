#! /bin/bash

KUBE_LINTER_VERSION="0.8.1"

if ! command -v kube-linter 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] kube-linter"
    # kube-linter - Kubernetes CLI
    curl  -LO "https://github.com/stackrox/kube-linter/releases/download/v$KUBE_LINTER_VERSION/kube-linter-linux.tar.gz"
    tar -xzf kube-linter-linux.tar.gz
    sudo cp kube-linter /usr/local/bin/kube-linter
    sudo chmod +x /usr/local/bin/kube-linter
    

    echo "[INFO] >>>> Clean Up"
    rm kube-linter-linux.tar.gz kube-linter LICENSE README.md

    if ! command -v kube-linter &> /dev/null; then
        echo "[FAIL ❌] kube-linter installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kube-linter command installed!"
else
    echo "[CHECKED ✅] kube-linter command exists"
fi