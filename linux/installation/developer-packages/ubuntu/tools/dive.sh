#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "dive_${DIVE_VERSION}_${OS}_${ARCH}.deb"
}

DIVE_VERSION=$(curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://api.github.com/repos/wagoodman/dive/releases/latest" \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if ! command -v dive &>/dev/null; then
    echo "[INSTALLING ⬇️] dive v${DIVE_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install dive
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_${OS}_${ARCH}.deb" \
            -o "dive_${DIVE_VERSION}_${OS}_${ARCH}.deb"
        sudo dpkg -i "dive_${DIVE_VERSION}_${OS}_${ARCH}.deb"
        clean_up
    fi

    if ! command -v dive &>/dev/null; then
        echo "[FAIL ❌] dive installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] dive command installed!"
else
    echo "[CHECKED ✅] dive command exists"
fi