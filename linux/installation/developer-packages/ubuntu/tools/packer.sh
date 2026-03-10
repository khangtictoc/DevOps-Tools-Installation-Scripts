#! /bin/bash

if ! command -v packer 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Packer"
    curl -fsSL  https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install -y packer

    if ! command -v packer &> /dev/null; then
        echo "[FAIL ❌] packer installation failed!"
        exit 1
    fi
    
    echo "[CHECKED ✅] packer command installed!"
else
    echo "[CHECKED ✅] packer command exists"
fi