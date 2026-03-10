#! /bin/bash

HELM_VERSION=3.16.4

if ! command -v helm 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Helm"

    wget https://get.helm.sh/helm-v${HELM_VERSION:-3.16.4}-linux-amd64.tar.gz
    tar -zxvf helm-v${HELM_VERSION:-v3.16.4}-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm

    echo "[INFO] >>>> Clean Up"
    rm -f helm-v${HELM_VERSION:-v3.16.4}-linux-amd64.tar.gz
    rm -drf linux-amd64

    if ! command -v helm &> /dev/null; then
        echo "[FAIL ❌] helm installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] helm command installed!"
else
    echo "[CHECKED ✅] helm command exists"
fi