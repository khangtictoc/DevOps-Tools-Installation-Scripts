#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "glab_${GLAB_VERSION}_${OS}_${ARCH}.deb"
}

GLAB_VERSION="1.67.0"

if ! command -v glab &>/dev/null; then
    echo "[INSTALLING ⬇️] GitLab CLI"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install glab
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_${OS}_${ARCH}.deb" \
            -o "glab_${GLAB_VERSION}_${OS}_${ARCH}.deb"
        sudo dpkg -i "glab_${GLAB_VERSION}_${OS}_${ARCH}.deb"
        clean_up
    fi

    if ! command -v glab &>/dev/null; then
        echo "[FAIL ❌] glab installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] glab command installed!"
else
    echo "[CHECKED ✅] glab command exists"
fi