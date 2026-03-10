#!/usr/bin/env bash

if ! command -v vault &>/dev/null; then
    echo "[INSTALLING ⬇️] Vault"

    case "$(uname -s)" in
        Darwin)
            brew tap hashicorp/tap
            brew install hashicorp/tap/vault
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://apt.releases.hashicorp.com/gpg \
                | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
                | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

            sudo apt update
            sudo apt install -y vault
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v vault &>/dev/null; then
        echo "[FAIL ❌] vault installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] vault command installed!"
else
    echo "[CHECKED ✅] vault command exists"
fi