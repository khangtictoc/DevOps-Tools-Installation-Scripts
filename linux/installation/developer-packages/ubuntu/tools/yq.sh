#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

YQ_VERSION="v4.46.1"
YQ_BINARY="yq_${OS}_${ARCH}"

if ! command -v yq &>/dev/null; then
    echo "[INSTALLING ⬇️] yq"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz" \
        | tar xz && sudo mv ${YQ_BINARY} /usr/local/bin/yq

    if ! command -v yq &> /dev/null; then
        echo "[FAIL ❌] yq installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] yq command installed!"
else
    echo "[CHECKED ✅] yq command exists"
fi