#! /bin/bash

THEME='catppuccin-mocha'
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/config.yml"

if ! command -v k9s || ! command -v xclip 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] k9s"
    wget https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_linux_amd64.deb
    sudo apt install ./k9s_linux_amd64.deb

    echo "[INFO] >>>> Clean Up"
    rm k9s_linux_amd64.deb

    echo "[INSTALLING ⬇️ ] xclip (For copy content)"
    sudo apt update
    sudo apt install -y xclip

    if ! command -v k9s  &> /dev/null; then
        echo "[FAIL ❌] k9s installation failed!"
        exit 1
    fi

    if ! command -v xclip  &> /dev/null; then
        echo "[FAIL ❌] xclip installation failed!"
        exit 1
    fi

    echo "[INFO] Config K9s Theme"
    OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
    mkdir -p "$OUT"
    curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist
    yq -i ".k9s.ui.skin = $THEME" "$CONFIG_FILE"

    echo "[CHECKED ✅] k9s's theme configured!"

    echo "[CHECKED ✅] k9s command installed!"
else
    echo "[CHECKED ✅] k9s command exists"
fi