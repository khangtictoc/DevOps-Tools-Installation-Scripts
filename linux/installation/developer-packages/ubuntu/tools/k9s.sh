#!/usr/bin/env bash

K9S_VERSION="0.32.7"
THEME="catppuccin-mocha"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/config.yml"

# --- Install k9s ------------------------------------------------
if ! command -v k9s &>/dev/null; then
    echo "[INSTALLING ⬇️] k9s v${K9S_VERSION}"

    case "$(uname -s)" in
        Darwin)
            brew install derailed/k9s/k9s
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_linux_${arch}.deb" \
                -o "k9s_linux_${arch}.deb"
            sudo apt install -y "./k9s_linux_${arch}.deb"

            echo "[INFO] Clean up"
            rm "k9s_linux_${arch}.deb"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

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
if [[ "$(uname -s)" == "Linux" ]] && ! command -v xclip &>/dev/null; then
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
yq -i ".k9s.ui.skin = \"$THEME\"" "$CONFIG_FILE"

echo "[CHECKED ✅] k9s theme configured!"