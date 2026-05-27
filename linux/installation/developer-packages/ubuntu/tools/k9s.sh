#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

K9S_VERSION="0.32.7"
THEME="catppuccin-mocha"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/config.yaml"

# --- Install k9s ------------------------------------------------
if ! command -v k9s &>/dev/null; then
    echo "[INSTALLING ⬇️] k9s v${K9S_VERSION}"

    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install derailed/k9s/k9s
    else
        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_${OS}_${ARCH}.deb" \
            -o "k9s_${OS}_${ARCH}.deb"
        sudo dpkg -i "./k9s_${OS}_${ARCH}.deb"

        echo "[INFO] Clean up"
        rm "k9s_${OS}_${ARCH}.deb"
    fi

    if ! command -v k9s &>/dev/null; then
        echo "[FAIL ❌] k9s installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] k9s command installed!"
else
    echo "[CHECKED ✅] k9s command exists"
fi

# --- Install clipboard tool -------------------------------------
# macOS has pbcopy built-in; xclip only needed on Linux
if [[ "$OS" == "linux" ]] && ! command -v xclip &>/dev/null; then
    echo "[INSTALLING ⬇️] xclip"
    sudo apt update
    sudo apt install -y xclip

    if ! command -v xclip &>/dev/null; then
        echo "[FAIL ❌] xclip installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] xclip command installed!"
fi

# --- Configure k9s theme ----------------------------------------

echo "[INFO] Configuring k9s theme: ${THEME}"
OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
mkdir -p "$OUT"
curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://github.com/catppuccin/k9s/archive/main.tar.gz \
    | tar xz -C "$OUT" --strip-components=2 k9s-main/dist
yq -y -i ".k9s.ui.skin = \"$THEME\"" "$CONFIG_FILE"

echo "[CHECKED ✅] k9s theme configured!"