#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v ngrok &>/dev/null; then
    echo "[INSTALLING ⬇️] ngrok"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install ngrok/ngrok/ngrok
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
            | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
        echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
            | sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null
        sudo apt update
        sudo apt install -y ngrok
    fi

    if ! command -v ngrok &>/dev/null; then
        echo "[FAIL ❌] ngrok installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ngrok command installed!"
else
    echo "[CHECKED ✅] ngrok command exists"
fi