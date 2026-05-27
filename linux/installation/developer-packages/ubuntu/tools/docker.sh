#!/usr/bin/env bash

# Note: Available script provided by Official Docker at: https://get.docker.com does not support old Ubuntu. This script is better.

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v docker &>/dev/null; then
    echo "[INSTALLING ⬇️] Docker"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install --cask docker
        echo "[INFO] Docker Desktop installed. Please launch it manually to complete setup."
    else
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        docker run hello-world
    fi

    if ! command -v docker &>/dev/null; then
        echo "[FAIL ❌] docker installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] docker command installed!"
else
    echo "[CHECKED ✅] docker command exists"
fi