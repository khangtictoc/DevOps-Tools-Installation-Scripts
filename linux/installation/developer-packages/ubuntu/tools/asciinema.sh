#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

ASCIINEMA_VERSION="v3.0.1"

detect_asciinema_binary() {
    local asciinema_os asciinema_arch
    case "$OS" in
        darwin) asciinema_os="apple-darwin" ;;
        linux)  asciinema_os="unknown-linux-musl" ;;
    esac
    case "$ARCH" in
        amd64) asciinema_arch="x86_64"  ;;
        arm64) asciinema_arch="aarch64" ;;
    esac
    echo "asciinema-${asciinema_arch}-${asciinema_os}"
}

if ! command -v asciinema &>/dev/null; then
    BINARY=$(detect_asciinema_binary)
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL \
        "https://github.com/asciinema/asciinema/releases/download/${ASCIINEMA_VERSION}/${BINARY}" \
        -o asciinema
    sudo install asciinema /usr/local/bin/asciinema
    rm asciinema
    echo "[INFO] Clean up"

    if ! command -v asciinema &>/dev/null; then
        echo "[FAIL ❌] asciinema installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] asciinema command installed!"
else
    echo "[CHECKED ✅] asciinema command exists!"
fi