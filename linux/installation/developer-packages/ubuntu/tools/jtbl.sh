#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$TARBALL"
}

JTBL_VERSION="1.6.0"

if ! command -v jtbl &>/dev/null; then
    echo "[INSTALLING ⬇️] jtbl v${JTBL_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install jtbl
    else
        case "$ARCH" in
            amd64) jtbl_arch="x86_64"  ;;
            arm64) jtbl_arch="aarch64" ;;
        esac

        TARBALL="jtbl-${JTBL_VERSION}-linux-${jtbl_arch}.tar.gz"
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/kellyjonbrazil/jtbl/releases/download/v${JTBL_VERSION}/${TARBALL}" \
            -o "$TARBALL"
        tar -xzf "$TARBALL"
        sudo mv jtbl /usr/local/bin/jtbl
        clean_up
    fi

    if ! command -v jtbl &>/dev/null; then
        echo "[FAIL ❌] jtbl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] jtbl command installed!"
else
    echo "[CHECKED ✅] jtbl command exists"
fi