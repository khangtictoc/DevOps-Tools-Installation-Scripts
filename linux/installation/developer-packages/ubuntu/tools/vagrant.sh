#!/usr/bin/env bash

if ! command -v vagrant &>/dev/null; then
    echo "[INSTALLING ⬇️] Vagrant"

    case "$(uname -s)" in
        Darwin)
            brew install --cask vagrant
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://apt.releases.hashicorp.com/gpg \
                | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
                | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
            sudo apt update && sudo apt install -y vagrant
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v vagrant &>/dev/null; then
        echo "[FAIL ❌] vagrant installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] vagrant command installed!"

    # Plugin install — use env var flag or fall back to interactive prompt
    if [ -z "$INSTALL_VAGRANT_PLUGINS" ]; then
        read -p "Do you want to install Vagrant plugins? (y/n): " CONFIRM
    else
        CONFIRM="$INSTALL_VAGRANT_PLUGINS"
    fi

    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        vagrant plugin install vagrant-vmware-desktop
        echo "[CHECKED ✅] vagrant plugins installed!"
    else
        echo "[INFO] Skipping Vagrant plugins installation."
    fi

else
    echo "[CHECKED ✅] vagrant command exists"
fi