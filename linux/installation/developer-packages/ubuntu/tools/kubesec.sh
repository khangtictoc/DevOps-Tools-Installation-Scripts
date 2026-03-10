#!/usr/bin/env bash

KUBESEC_VERSION="2.14.2"

if ! command -v kubesec &>/dev/null; then
    echo "[INSTALLING ⬇️] kubesec v${KUBESEC_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew install kubesec
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            TARBALL="kubesec_linux_${arch}.tar.gz"
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/${TARBALL}" \
                -o "$TARBALL"
            tar -xzf "$TARBALL"
            sudo cp kubesec /usr/local/bin/kubesec
            sudo chmod +x /usr/local/bin/kubesec

            echo "[INFO] Clean up"
            rm -f "$TARBALL" kubesec LICENSE README.md CHANGELOG.md
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v kubesec &>/dev/null; then
        echo "[FAIL ❌] kubesec installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubesec command installed!"
else
    echo "[CHECKED ✅] kubesec command exists"
fi