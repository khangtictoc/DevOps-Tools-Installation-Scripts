#!/usr/bin/env bash

ANACONDA_VERSION="2025.06-0"

detect_anaconda_platform() {
    local os arch

    case "$(uname -s)" in
        Darwin) os="MacOSX" ;;
        Linux)  os="Linux"  ;;
        *) echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="x86_64"  ;;
        arm64 | aarch64) arch="aarch64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "Anaconda3-${ANACONDA_VERSION}-${os}-${arch}.sh"
}

if ! command -v conda &>/dev/null; then
    INSTALLER=$(detect_anaconda_platform)

    echo "[INFO] Downloading $INSTALLER..."
    curl -fsSL "https://repo.anaconda.com/archive/$INSTALLER" -o "$INSTALLER"

    bash "$INSTALLER" -u << EOF

yes

yes
EOF

    echo "[INFO] >>>> Clean Up"
    rm "$INSTALLER"

    echo "[CHECKED ✅] Anaconda installed! Try 'conda -h'"
else
    echo "[CHECKED ✅] Anaconda already installed! Try 'conda -h'"
fi