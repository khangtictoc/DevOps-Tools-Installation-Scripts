#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

TFG_VERSION="0.94.0"

if ! command -v terragrunt &>/dev/null; then
    echo "[INSTALLING ⬇️] Terragrunt v${TFG_VERSION}"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TFG_VERSION}/terragrunt_${OS}_${ARCH}" \
        -o terragrunt
    sudo chmod +x terragrunt
    sudo mv terragrunt /usr/local/bin/terragrunt

    if ! command -v terragrunt &>/dev/null; then
        echo "[FAIL ❌] terragrunt installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] terragrunt command installed!"
else
    echo "[CHECKED ✅] terragrunt command exists"
fi