#!/usr/bin/env bash

TAWS_VERSION="1.3.0-rc.4"

detect_taws_platform() {
    case "$(uname -s)" in
        Darwin)
            case "$(uname -m)" in
                x86_64)          echo "x86_64-apple-darwin"       ;;
                arm64 | aarch64) echo "aarch64-apple-darwin"      ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          echo "x86_64-unknown-linux-musl"  ;;
                arm64 | aarch64) echo "aarch64-unknown-linux-musl" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac
}

if ! command -v taws &>/dev/null; then
    echo "[INSTALLING ⬇️] taws v${TAWS_VERSION}"
    PLATFORM=$(detect_taws_platform)
    TARBALL="taws-${PLATFORM}.tar.gz"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/huseyinbabal/taws/releases/download/v${TAWS_VERSION}/${TARBALL}" \
        -o "$TARBALL"
    sudo tar -xzf "$TARBALL" -C /usr/local/bin taws
    sudo chmod +x /usr/local/bin/taws

    echo "[INFO] Clean up"
    rm -f "$TARBALL"

    if ! command -v taws &>/dev/null; then
        echo "[FAIL ❌] taws installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] taws command installed!"
else
    echo "[CHECKED ✅] taws command exists"
fi