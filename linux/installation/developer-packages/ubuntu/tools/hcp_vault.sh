#! /bin/bash

if ! command -v vault 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Vault"
    wget \
        -O - https://apt.releases.hashicorp.com/gpg \
        | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list
        
    sudo apt update

    if sudo apt install -y vault; then
        echo "Vault installed successfully with apt."
    else
        echo "apt installation failed, trying snap..."
        if sudo snap install vault; then
            echo "Vault installed successfully with snap."
        else
            echo "Both apt and snap installation failed."
        fi
    fi

    if ! command -v vault &> /dev/null; then
        echo "[FAIL ❌] vault installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] vault command installed!"
else
    echo "[CHECKED ✅] vault command exists"
fi