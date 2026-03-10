#!/usr/bin/env bash

if ! command -v gcloud &>/dev/null; then
    echo "[INSTALLING ⬇️] Google Cloud CLI"

    case "$(uname -s)" in
        Darwin)
            brew install --cask google-cloud-sdk
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
                | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg
            echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
                | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
            sudo apt-get update && sudo apt-get install -y google-cloud-cli
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v gcloud &>/dev/null; then
        echo "[FAIL ❌] gcloud installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] gcloud command installed!"
else
    echo "[CHECKED ✅] gcloud command exists"
fi