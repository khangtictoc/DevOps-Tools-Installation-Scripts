#!/usr/bin/env bash

TUFW_CLI_VERSION="0.2.4"

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "[SKIP] tufw is Linux-only (requires ufw). Skipping on $(uname -s)."
    exit 0
fi

if ! command -v tufw &>/dev/null; then
    echo "[INSTALLING ⬇️] tufw v${TUFW_CLI_VERSION}"

    case "$(uname -m)" in
        x86_64)          arch="amd64" ;;
        arm64 | aarch64) arch="arm64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    DEB="tufw_${TUFW_CLI_VERSION}_linux_${arch}.deb"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/peltho/tufw/releases/download/v${TUFW_CLI_VERSION}/${DEB}" \
        -o "$DEB"
    sudo dpkg -i "$DEB"

    echo "[INFO] Clean up"
    rm -f "$DEB"

    if ! command -v tufw &>/dev/null; then
        echo "[FAIL ❌] tufw installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] tufw command installed!"
else
    echo "[CHECKED ✅] tufw command exists"
fi