#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f kubectl
}

if ! command -v kubectl &>/dev/null; then
    echo "[INSTALLING ⬇️] kubectl"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install kubectl
    else
        STABLE=$(curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://dl.k8s.io/release/stable.txt)
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://dl.k8s.io/release/${STABLE}/bin/${OS}/${ARCH}/kubectl" -o kubectl
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        clean_up
    fi

    if ! command -v kubectl &>/dev/null; then
        echo "[FAIL ❌] kubectl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubectl command installed!"
else
    echo "[CHECKED ✅] kubectl command exists"
fi