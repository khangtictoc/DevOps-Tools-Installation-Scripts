#!/usr/bin/env bash

TFG_VERSION="0.94.0"

if ! command -v terragrunt &>/dev/null; then
    echo "[INSTALLING ⬇️] Terragrunt v${TFG_VERSION}"

    case "$(uname -s)" in
        Darwin)
            case "$(uname -m)" in
                x86_64)          arch="darwin_amd64" ;;
                arm64 | aarch64) arch="darwin_arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="linux_amd64" ;;
                arm64 | aarch64) arch="linux_arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TFG_VERSION}/terragrunt_${arch}" \
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