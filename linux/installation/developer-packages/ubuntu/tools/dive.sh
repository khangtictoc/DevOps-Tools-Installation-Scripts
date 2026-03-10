#!/usr/bin/env bash

DIVE_VERSION=$(curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://api.github.com/repos/wagoodman/dive/releases/latest" \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if ! command -v dive &>/dev/null; then
    echo "[INSTALLING ⬇️] dive v${DIVE_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew install dive
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_${arch}.deb" \
                -o "dive_${DIVE_VERSION}_linux_${arch}.deb"
            sudo dpkg -i "dive_${DIVE_VERSION}_linux_${arch}.deb"

            echo "[INFO] Clean up"
            rm -f "dive_${DIVE_VERSION}_linux_${arch}.deb"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v dive &>/dev/null; then
        echo "[FAIL ❌] dive installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] dive command installed!"
else
    echo "[CHECKED ✅] dive command exists"
fi