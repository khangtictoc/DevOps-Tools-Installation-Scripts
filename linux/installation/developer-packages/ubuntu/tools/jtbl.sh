#!/usr/bin/env bash

JTBL_VERSION="1.6.0"

if ! command -v jtbl &>/dev/null; then
    echo "[INSTALLING ⬇️] jtbl v${JTBL_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew install jtbl
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="x86_64" ;;
                arm64 | aarch64) arch="aarch64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            TARBALL="jtbl-${JTBL_VERSION}-linux-${arch}.tar.gz"
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/kellyjonbrazil/jtbl/releases/download/v${JTBL_VERSION}/${TARBALL}" \
                -o "$TARBALL"
            tar -xzf "$TARBALL"
            sudo mv jtbl /usr/local/bin/jtbl

            echo "[INFO] Clean up"
            rm -f "$TARBALL"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v jtbl &>/dev/null; then
        echo "[FAIL ❌] jtbl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] jtbl command installed!"
else
    echo "[CHECKED ✅] jtbl command exists"
fi