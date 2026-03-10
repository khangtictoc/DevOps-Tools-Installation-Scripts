#!/usr/bin/env bash

detect_aws_url() {
    case "$(uname -s)" in
        Darwin) os="macos" ;;
        Linux)  os="linux" ;;
        *) echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="x86_64"  ;;
        arm64 | aarch64) arch="aarch64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "https://awscli.amazonaws.com/awscli-exe-${os}-${arch}.zip"
}

if ! command -v aws &>/dev/null; then
    echo "[INSTALLING ⬇️] AWS CLI"
    URL=$(detect_aws_url)

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "$URL" -o awscliv2.zip
    unzip awscliv2.zip
    sudo ./aws/install

    echo "[INFO] Clean up"
    rm -f awscliv2.zip && rm -rf aws

    if ! command -v aws &>/dev/null; then
        echo "[FAIL ❌] aws installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] aws command installed!"
else
    echo "[CHECKED ✅] aws command exists!"
fi