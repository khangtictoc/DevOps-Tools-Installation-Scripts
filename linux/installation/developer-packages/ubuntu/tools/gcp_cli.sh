#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v gcloud &>/dev/null; then
    echo "[INSTALLING ⬇️] Google Cloud CLI"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install --cask google-cloud-sdk
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
            | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
            | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
        sudo apt-get update && sudo apt-get install -y google-cloud-cli
    fi

    if ! command -v gcloud &>/dev/null; then
        echo "[FAIL ❌] gcloud installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] gcloud command installed!"
else
    echo "[CHECKED ✅] gcloud command exists"
fi