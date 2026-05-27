#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -rf "$TARBALL" "velero-${VELERO_VERSION}-${OS}-${ARCH}"
}

VELERO_VERSION="v1.17.0"

if ! command -v velero &>/dev/null; then
    echo "[INSTALLING ⬇️] Velero ${VELERO_VERSION}"

    TARBALL="velero-${VELERO_VERSION}-${OS}-${ARCH}.tar.gz"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/${TARBALL}" \
        -o "$TARBALL"
    tar -xzf "$TARBALL"
    sudo cp "velero-${VELERO_VERSION}-${OS}-${ARCH}/velero" /usr/local/bin/velero
    clean_up

    if ! command -v velero &>/dev/null; then
        echo "[FAIL ❌] velero installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] velero command installed!"
else
    echo "[CHECKED ✅] velero command exists!"
fi