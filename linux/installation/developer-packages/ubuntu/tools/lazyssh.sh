#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$TARBALL"
}

detect_lazyssh_platform() {
    local lazyssh_os lazyssh_arch
    case "$OS" in
        darwin) lazyssh_os="Darwin" ;;
        linux)  lazyssh_os="Linux"  ;;
    esac
    case "$ARCH" in
        amd64) lazyssh_arch="x86_64"  ;;
        arm64) lazyssh_arch="arm64"   ;;
    esac
    echo "${lazyssh_os}_${lazyssh_arch}"
}

if ! command -v lazyssh &>/dev/null; then
    echo "[INSTALLING ⬇️] lazyssh"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install Adembc/homebrew-tap/lazyssh
    else
        LATEST_TAG=$(curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        PLATFORM=$(detect_lazyssh_platform)
        TARBALL="lazyssh_${PLATFORM}.tar.gz"

        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/Adembc/lazyssh/releases/download/${LATEST_TAG}/${TARBALL}" \
            -o "$TARBALL"
        tar -xzf "$TARBALL"
        sudo mv lazyssh /usr/local/bin/lazyssh
        clean_up
    fi

    if ! command -v lazyssh &>/dev/null; then
        echo "[FAIL ❌] lazyssh installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] lazyssh command installed!"
else
    echo "[CHECKED ✅] lazyssh command exists"
fi