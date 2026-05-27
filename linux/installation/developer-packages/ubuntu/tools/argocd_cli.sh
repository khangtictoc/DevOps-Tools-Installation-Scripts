#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

ARGO_CLI_VERSION="v3.0.16"

if ! command -v argocd &>/dev/null; then
    echo "[INSTALLING ⬇️] ArgoCD CLI"
    BINARY="argocd-${OS}-${ARCH}"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/argoproj/argo-cd/releases/download/${ARGO_CLI_VERSION}/${BINARY}" -o argocd
    sudo chmod +x argocd
    sudo mv argocd /usr/local/bin/argocd

    if ! command -v argocd &>/dev/null; then
        echo "[FAIL ❌] argocd installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] argocd command installed!"
else
    echo "[CHECKED ✅] argocd command exists"
fi