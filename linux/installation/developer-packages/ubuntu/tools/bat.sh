#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "bat_${BAT_VERSION}_${ARCH}.deb"
}

BAT_VERSION="0.26.1"

if ! command -v bat &>/dev/null; then
    echo "[INSTALLING ⬇️] bat"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install bat
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCH}.deb" \
            -o "bat_${BAT_VERSION}_${ARCH}.deb"
        sudo dpkg -i "bat_${BAT_VERSION}_${ARCH}.deb"
        clean_up
    fi

    if ! command -v bat &>/dev/null; then
        echo "[FAIL ❌] bat installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] bat command installed!"
else
    echo "[CHECKED ✅] bat command exists"
fi