#!/usr/bin/env bash

if ! command -v packer &>/dev/null; then
    echo "[INSTALLING ⬇️] Packer"

    case "$(uname -s)" in
        Darwin)
            brew tap hashicorp/tap
            brew install hashicorp/tap/packer
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://apt.releases.hashicorp.com/gpg \
                | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
                | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
            sudo apt-get update && sudo apt-get install -y packer
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v packer &>/dev/null; then
        echo "[FAIL ❌] packer installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] packer command installed!"
else
    echo "[CHECKED ✅] packer command exists"
fi