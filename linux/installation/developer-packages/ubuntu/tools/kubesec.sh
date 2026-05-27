#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$TARBALL" kubesec LICENSE README.md CHANGELOG.md
}

KUBESEC_VERSION="2.14.2"

if ! command -v kubesec &>/dev/null; then
    echo "[INSTALLING ⬇️] kubesec v${KUBESEC_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install kubesec
    else
        TARBALL="kubesec_${OS}_${ARCH}.tar.gz"
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/${TARBALL}" \
            -o "$TARBALL"
        tar -xzf "$TARBALL"
        sudo cp kubesec /usr/local/bin/kubesec
        sudo chmod +x /usr/local/bin/kubesec
        clean_up
    fi

    if ! command -v kubesec &>/dev/null; then
        echo "[FAIL ❌] kubesec installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubesec command installed!"
else
    echo "[CHECKED ✅] kubesec command exists"
fi