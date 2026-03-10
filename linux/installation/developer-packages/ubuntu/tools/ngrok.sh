#!/usr/bin/env bash

if ! command -v ngrok &>/dev/null; then
    echo "[INSTALLING ⬇️] ngrok"

    case "$(uname -s)" in
        Darwin)
            brew install ngrok/ngrok/ngrok
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
                | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
            echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
                | sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null
            sudo apt update
            sudo apt install -y ngrok
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v ngrok &>/dev/null; then
        echo "[FAIL ❌] ngrok installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ngrok command installed!"
else
    echo "[CHECKED ✅] ngrok command exists"
fi