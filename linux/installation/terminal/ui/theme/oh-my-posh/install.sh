#!/usr/bin/env bash

set -e

# --- Pinned version -------------------------------------------
OH_MY_POSH_VERSION="24.19.0"

# --- Detect OS/arch for the correct binary --------------------
detect_platform() {
    local os arch

    case "$(uname -s)" in
        Darwin) os="darwin" ;;
        Linux)  os="linux"  ;;
        *)      echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="amd64"  ;;
        arm64 | aarch64) arch="arm64"  ;;
        *)               echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "posh-${os}-${arch}"
}

# --- Install --------------------------------------------------
BINARY_NAME=$(detect_platform)
INSTALL_DIR="$HOME/.local/bin"
DOWNLOAD_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${OH_MY_POSH_VERSION}/${BINARY_NAME}"

mkdir -p "$INSTALL_DIR"

if command -v oh-my-posh &>/dev/null; then
    CURRENT_VERSION=$(oh-my-posh version 2>/dev/null || echo "unknown")
    if [[ "$CURRENT_VERSION" == "$OH_MY_POSH_VERSION" ]]; then
        echo "[INFO] oh-my-posh v$OH_MY_POSH_VERSION is already installed. Skipping."
        exit 0
    else
        echo "[INFO] Replacing oh-my-posh v$CURRENT_VERSION → v$OH_MY_POSH_VERSION"
    fi
fi

echo "[INFO] Downloading oh-my-posh v${OH_MY_POSH_VERSION} (${BINARY_NAME})..."
curl -fsSL "$DOWNLOAD_URL" -o "$INSTALL_DIR/oh-my-posh"
chmod +x "$INSTALL_DIR/oh-my-posh"

# --- Ensure it's on PATH (macOS / systems without ~/.local/bin in PATH) ---
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    # Fallback: symlink to /usr/local/bin (requires sudo, Ubuntu/Linux only)
    if [[ "$(uname -s)" == "Linux" ]]; then
        sudo ln -sf "$INSTALL_DIR/oh-my-posh" /usr/local/bin/oh-my-posh
        echo "[INFO] Symlinked to /usr/local/bin/oh-my-posh"
    fi
fi

echo "[INFO] oh-my-posh v${OH_MY_POSH_VERSION} installed successfully at $INSTALL_DIR/oh-my-posh"
oh-my-posh version