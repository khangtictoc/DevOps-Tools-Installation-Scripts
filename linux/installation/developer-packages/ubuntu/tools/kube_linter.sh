#!/usr/bin/env bash

KUBE_LINTER_VERSION="0.8.1"

if ! command -v kube-linter &>/dev/null; then
    echo "[INSTALLING ⬇️] kube-linter v${KUBE_LINTER_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew install kube-linter
            ;;
        Linux)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/stackrox/kube-linter/releases/download/v${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz" \
                -o kube-linter-linux.tar.gz
            tar -xzf kube-linter-linux.tar.gz
            sudo cp kube-linter /usr/local/bin/kube-linter
            sudo chmod +x /usr/local/bin/kube-linter

            echo "[INFO] Clean up"
            rm -f kube-linter-linux.tar.gz kube-linter LICENSE README.md
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v kube-linter &>/dev/null; then
        echo "[FAIL ❌] kube-linter installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kube-linter command installed!"
else
    echo "[CHECKED ✅] kube-linter command exists"
fi