#!/usr/bin/env bash

ARGO_CLI_VERSION="v3.0.16"

detect_argocd_binary() {
    case "$(uname -s)" in
        Darwin) os="darwin" ;;
        Linux)  os="linux"  ;;
        *) echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="amd64" ;;
        arm64 | aarch64) arch="arm64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "argocd-${os}-${arch}"
}

if ! command -v argocd &>/dev/null; then
    echo "[INSTALLING ⬇️] ArgoCD CLI"
    BINARY=$(detect_argocd_binary)
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