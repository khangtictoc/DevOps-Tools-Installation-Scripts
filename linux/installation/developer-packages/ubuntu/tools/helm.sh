#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

HELM_VERSION="3.16.4"

if ! command -v helm &>/dev/null; then
    echo "[INSTALLING ⬇️] Helm v${HELM_VERSION}"
    PLATFORM="${OS}-${ARCH}"
    TARBALL="helm-v${HELM_VERSION}-${PLATFORM}.tar.gz"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://get.helm.sh/${TARBALL}" -o "$TARBALL"
    tar -zxf "$TARBALL"
    sudo mv "${PLATFORM}/helm" /usr/local/bin/helm

    echo "[INFO] Clean up"
    rm -f "$TARBALL"
    rm -rf "$PLATFORM"

    if ! command -v helm &>/dev/null; then
        echo "[FAIL ❌] helm installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] helm command installed!"
else
    echo "[CHECKED ✅] helm command exists"
fi