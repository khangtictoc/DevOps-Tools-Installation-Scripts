#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

detect_aws_url() {
    local aws_os aws_arch
    case "$OS" in
        darwin) aws_os="macos" ;;
        linux)  aws_os="linux" ;;
    esac
    case "$ARCH" in
        amd64) aws_arch="x86_64"  ;;
        arm64) aws_arch="aarch64" ;;
    esac
    echo "https://awscli.amazonaws.com/awscli-exe-${aws_os}-${aws_arch}.zip"
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