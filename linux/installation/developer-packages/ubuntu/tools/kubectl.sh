#!/usr/bin/env bash

if ! command -v kubectl &>/dev/null; then
    echo "[INSTALLING ⬇️] kubectl"

    case "$(uname -s)" in
        Darwin)
            brew install kubectl
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            STABLE=$(curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://dl.k8s.io/release/stable.txt)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://dl.k8s.io/release/${STABLE}/bin/linux/${arch}/kubectl" -o kubectl
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

            echo "[INFO] Clean up"
            rm kubectl
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v kubectl &>/dev/null; then
        echo "[FAIL ❌] kubectl installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubectl command installed!"
else
    echo "[CHECKED ✅] kubectl command exists"
fi