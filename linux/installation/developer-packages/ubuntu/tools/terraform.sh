#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

TF_VERSION="1.10.3"

if ! command -v terraform &>/dev/null; then
    echo "[INSTALLING ⬇️] Terraform v${TF_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
    else
        ZIP="terraform_${TF_VERSION}_${OS}_${ARCH}.zip"
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://releases.hashicorp.com/terraform/${TF_VERSION}/${ZIP}" -o "$ZIP"
        unzip "$ZIP"
        sudo mv terraform /usr/local/bin/terraform

        echo "[INFO] Clean up"
        rm -f "$ZIP" LICENSE.txt
    fi

    if ! command -v terraform &>/dev/null; then
        echo "[FAIL ❌] terraform installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] terraform command installed!"
else
    echo "[CHECKED ✅] terraform command exists"
fi