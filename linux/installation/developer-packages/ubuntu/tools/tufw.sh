#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$DEB"
}

TUFW_CLI_VERSION="0.2.4"

if [[ "$OS" != "linux" ]]; then
    echo "[SKIP] tufw is Linux-only (requires ufw). Skipping on $OS."
    exit 0
fi

if ! command -v tufw &>/dev/null; then
    echo "[INSTALLING ⬇️] tufw v${TUFW_CLI_VERSION}"

    DEB="tufw_${TUFW_CLI_VERSION}_${OS}_${ARCH}.deb"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/peltho/tufw/releases/download/v${TUFW_CLI_VERSION}/${DEB}" \
        -o "$DEB"
    sudo dpkg -i "$DEB"
    clean_up

    if ! command -v tufw &>/dev/null; then
        echo "[FAIL ❌] tufw installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] tufw command installed!"
else
    echo "[CHECKED ✅] tufw command exists"
fi