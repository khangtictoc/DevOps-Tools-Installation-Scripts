#! /bin/bash

VELERO_VERSION="v1.17.0"

if ! command -v velero 2>&1 >/dev/null
then
    wget "https://github.com/vmware-tanzu/velero/releases/download/$VELERO_VERSION/velero-$VELERO_VERSION-linux-amd64.tar.gz"
    tar xfvz velero-$VELERO_VERSION-linux-amd64.tar.gz
    sudo cp velero-$VELERO_VERSION-linux-amd64/velero /usr/local/bin

    echo "[INFO] >>>> Clean Up"
    rm -drf velero-$VELERO_VERSION-linux-amd64.tar.gz velero-$VELERO_VERSION-linux-amd64

    if ! command -v velero &> /dev/null; then
        echo "[FAIL ❌] velero installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] velero command installed!"
else
    echo "[CHECKED ✅] velero command exists!"
fi