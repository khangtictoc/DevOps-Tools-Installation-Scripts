#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$TARBALL"
}

TAWS_VERSION="1.3.0-rc.4"

detect_taws_platform() {
    local taws_os taws_arch
    case "$OS" in
        darwin) taws_os="apple-darwin" ;;
        linux)  taws_os="unknown-linux-musl" ;;
    esac
    case "$ARCH" in
        amd64) taws_arch="x86_64"  ;;
        arm64) taws_arch="aarch64" ;;
    esac
    echo "${taws_arch}-${taws_os}"
}

if ! command -v taws &>/dev/null; then
    echo "[INSTALLING ⬇️] taws v${TAWS_VERSION}"
    PLATFORM=$(detect_taws_platform)
    TARBALL="taws-${PLATFORM}.tar.gz"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/huseyinbabal/taws/releases/download/v${TAWS_VERSION}/${TARBALL}" \
        -o "$TARBALL"
    sudo tar -xzf "$TARBALL" -C /usr/local/bin taws
    sudo chmod +x /usr/local/bin/taws
    clean_up

    if ! command -v taws &>/dev/null; then
        echo "[FAIL ❌] taws installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] taws command installed!"
else
    echo "[CHECKED ✅] taws command exists"
fi