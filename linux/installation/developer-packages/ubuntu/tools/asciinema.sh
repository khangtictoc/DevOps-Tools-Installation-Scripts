#!/usr/bin/env bash

ASCIINEMA_VERSION="v3.0.1"

detect_asciinema_binary() {
    case "$(uname -s)" in
        Darwin) os="apple-darwin" ;;
        Linux)  os="unknown-linux-musl" ;;
        *) echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="x86_64"  ;;
        arm64 | aarch64) arch="aarch64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "asciinema-${arch}-${os}"
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