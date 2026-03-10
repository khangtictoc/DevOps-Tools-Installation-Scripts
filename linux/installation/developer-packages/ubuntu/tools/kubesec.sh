#! /bin/bash

KUBESEC_VERSION="2.14.2"

if ! command -v kubesec 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] kubesec"
    # kubesec - Kubernetes CLI
    curl  -LO "https://github.com/controlplaneio/kubesec/releases/download/v$KUBESEC_VERSION/kubesec_linux_amd64.tar.gz"
    tar -xzf kubesec_linux_amd64.tar.gz
    sudo cp kubesec /usr/local/bin/kubesec
    sudo chmod +x /usr/local/bin/kubesec
    

    echo "[INFO] >>>> Clean Up"
    rm kubesec_linux_amd64.tar.gz kubesec LICENSE README.md CHANGELOG.md

    if ! command -v kubesec &> /dev/null; then
        echo "[FAIL ❌] kubesec installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubesec command installed!"
else
    echo "[CHECKED ✅] kubesec command exists"
fi