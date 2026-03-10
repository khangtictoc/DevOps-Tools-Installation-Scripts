#! /bin/bash

YQ_VERSION=v4.46.1
YQ_BINARY=yq_linux_amd64

if ! command -v yq 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] yq"
    wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz -O - |\
    tar xz && sudo mv ${YQ_BINARY} /usr/local/bin/yq

    if ! command -v yq &> /dev/null; then
        echo "[FAIL ❌] yq installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] yq command installed!"
else
    echo "[CHECKED ✅] yq command exists"
fi