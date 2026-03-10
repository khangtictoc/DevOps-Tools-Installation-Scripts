#!/usr/bin/env bash

BAT_VERSION="0.26.1"

if ! command -v bat &>/dev/null; then
    echo "[INSTALLING ⬇️] bat"

    case "$(uname -s)" in
        Darwin)
            brew install bat
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64"  ;;
                arm64 | aarch64) arch="arm64"  ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${arch}.deb" \
                -o "bat_${BAT_VERSION}_${arch}.deb"
            sudo dpkg -i "bat_${BAT_VERSION}_${arch}.deb"

            echo "[INFO] Clean up"
            rm "bat_${BAT_VERSION}_${arch}.deb"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v bat &>/dev/null; then
        echo "[FAIL ❌] bat installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] bat command installed!"
else
    echo "[CHECKED ✅] bat command exists"
fi