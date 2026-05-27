#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$INSTALLER"
}

ANACONDA_VERSION="2025.06-0"

detect_anaconda_platform() {
    local anaconda_os anaconda_arch
    case "$OS" in
        darwin) anaconda_os="MacOSX" ;;
        linux)  anaconda_os="Linux"  ;;
    esac
    case "$ARCH" in
        amd64) anaconda_arch="x86_64"  ;;
        arm64) anaconda_arch="aarch64" ;;
    esac
    echo "Anaconda3-${ANACONDA_VERSION}-${anaconda_os}-${anaconda_arch}.sh"
}

if ! command -v conda &>/dev/null; then
    INSTALLER=$(detect_anaconda_platform)

    echo "[INFO] Downloading $INSTALLER..."
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://repo.anaconda.com/archive/$INSTALLER" -o "$INSTALLER"

    bash "$INSTALLER" -u << EOF

yes

yes
EOF
    clean_up

    echo "[CHECKED ✅] Anaconda installed! Try 'conda -h'"
else
    echo "[CHECKED ✅] Anaconda already installed! Try 'conda -h'"
fi