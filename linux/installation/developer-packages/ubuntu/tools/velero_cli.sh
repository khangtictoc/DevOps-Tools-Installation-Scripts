#!/usr/bin/env bash

VELERO_VERSION="v1.17.0"

if ! command -v velero &>/dev/null; then
    echo "[INSTALLING ⬇️] Velero ${VELERO_VERSION}"

    case "$(uname -s)" in
        Darwin)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            os="darwin"
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            os="linux"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    TARBALL="velero-${VELERO_VERSION}-${os}-${arch}.tar.gz"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/${TARBALL}" \
        -o "$TARBALL"
    tar -xzf "$TARBALL"
    sudo cp "velero-${VELERO_VERSION}-${os}-${arch}/velero" /usr/local/bin/velero

    echo "[INFO] Clean up"
    rm -rf "$TARBALL" "velero-${VELERO_VERSION}-${os}-${arch}"

    if ! command -v velero &>/dev/null; then
        echo "[FAIL ❌] velero installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] velero command installed!"
else
    echo "[CHECKED ✅] velero command exists!"
fi