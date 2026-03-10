#! /bin/bash

TF_VERSION="1.10.3"

if ! command -v terraform 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Terraform"
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
    unzip terraform_${TF_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/local/bin/terraform

    echo "[INFO] >>>> Clean Up"
    rm -f terraform_${TF_VERSION}_linux_amd64.zip
    rm -f LICENSE.txt

    if ! command -v terraform &> /dev/null; then
        echo "[FAIL ❌] terraform installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] terraform command installed!"
else
    echo "[CHECKED ✅] terraform command exists"
fi