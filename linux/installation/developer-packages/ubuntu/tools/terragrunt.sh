#! /bin/bash

TFG_VERSION="0.94.0"

if ! command -v terragrunt 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Terragrunt"
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TFG_VERSION}/terragrunt_linux_amd64
    sudo chmod u+x terragrunt_linux_amd64
    sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

    if ! command -v terragrunt &> /dev/null; then
        echo "[FAIL ❌] terragrunt installation failed!"
        exit 1
    fi
    
    echo "[CHECKED ✅] terragrunt command installed!"
else
    echo "[CHECKED ✅] terragrunt command exists"
fi

