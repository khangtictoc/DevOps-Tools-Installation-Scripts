#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v vault &>/dev/null; then
    echo "[INSTALLING ⬇️] Vault"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew tap hashicorp/tap
        brew install hashicorp/tap/vault
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://apt.releases.hashicorp.com/gpg \
            | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
            | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

        sudo apt update
        sudo apt install -y vault
    fi

    if ! command -v vault &>/dev/null; then
        echo "[FAIL ❌] vault installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] vault command installed!"
else
    echo "[CHECKED ✅] vault command exists"
fi