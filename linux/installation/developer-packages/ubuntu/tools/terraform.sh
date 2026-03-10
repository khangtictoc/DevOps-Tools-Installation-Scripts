#!/usr/bin/env bash

TF_VERSION="1.10.3"

if ! command -v terraform &>/dev/null; then
    echo "[INSTALLING ⬇️] Terraform v${TF_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64"  ;;
                arm64 | aarch64) arch="arm64"  ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            ZIP="terraform_${TF_VERSION}_linux_${arch}.zip"
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://releases.hashicorp.com/terraform/${TF_VERSION}/${ZIP}" -o "$ZIP"
            unzip "$ZIP"
            sudo mv terraform /usr/local/bin/terraform

            echo "[INFO] Clean up"
            rm -f "$ZIP" LICENSE.txt
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v terraform &>/dev/null; then
        echo "[FAIL ❌] terraform installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] terraform command installed!"
else
    echo "[CHECKED ✅] terraform command exists"
fi