#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "kube-linter-${OS}.tar.gz" kube-linter LICENSE README.md
}

KUBE_LINTER_VERSION="0.8.1"

if ! command -v kube-linter &>/dev/null; then
    echo "[INSTALLING ⬇️] kube-linter v${KUBE_LINTER_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install kube-linter
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/stackrox/kube-linter/releases/download/v${KUBE_LINTER_VERSION}/kube-linter-${OS}.tar.gz" \
            -o "kube-linter-${OS}.tar.gz"
        tar -xzf "kube-linter-${OS}.tar.gz"
        sudo cp kube-linter /usr/local/bin/kube-linter
        sudo chmod +x /usr/local/bin/kube-linter
        clean_up
    fi
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