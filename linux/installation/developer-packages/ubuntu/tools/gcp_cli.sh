#! /bin/bash

if ! command -v gcloud 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Google Cloud CLI"
    curl  https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
        | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update && sudo apt-get install -y google-cloud-cli

    if ! command -v gcloud &> /dev/null; then
        echo "[FAIL ❌] gcloud installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] gcloud command installed!"
else
    echo "[CHECKED ✅] gcloud command exists"
fi