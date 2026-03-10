#! /bin/bash

# Note: Available script provided by Official Docker at: https://get.docker.com  does not support for old Ubuntu. My script is better

if ! command -v docker 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Docker"
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL  https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    docker run hello-world

    if ! command -v docker &> /dev/null; then
        echo "[FAIL ❌] docker installation failed!"
        exit 1
    fi
    
    echo "[CHECKED ✅] docker command installed!"
else
    echo "[CHECKED ✅] docker command exists"
fi