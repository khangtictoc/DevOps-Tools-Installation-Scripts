#!/usr/bin/env bash

HELM_VERSION="3.16.4"

detect_helm_platform() {
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

    echo "${os}-${arch}"
}

if ! command -v helm &>/dev/null; then
    echo "[INSTALLING ⬇️] Helm v${HELM_VERSION}"
    PLATFORM=$(detect_helm_platform)
    TARBALL="helm-v${HELM_VERSION}-${PLATFORM}.tar.gz"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://get.helm.sh/${TARBALL}" -o "$TARBALL"
    tar -zxf "$TARBALL"
    sudo mv "${PLATFORM}/helm" /usr/local/bin/helm

    echo "[INFO] Clean up"
    rm -f "$TARBALL"
    rm -rf "$PLATFORM"

    if ! command -v helm &>/dev/null; then
        echo "[FAIL ❌] helm installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] helm command installed!"
else
    echo "[CHECKED ✅] helm command exists"
fi