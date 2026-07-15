#!/usr/bin/env bash
set -euo pipefail

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

RUSTNET_VERSION="v1.3.0"

clean_up() {
    echo "[INFO] Clean up"
    rm -f Rustnet_LinuxDEB_amd64.deb
    rm -f RustNet_macOS_AppleSilicon.dmg
    rm -f RustNet_macOS_Intel.dmg
}

install_macos() {
    if [[ "$ARCH" == "arm64" ]]; then
        DMG_NAME="RustNet_macOS_AppleSilicon.dmg"
    else
        DMG_NAME="RustNet_macOS_Intel.dmg"
    fi

    echo "[INSTALLING ⬇️] Rustnet on macOS"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -L "https://github.com/domcyrus/rustnet/releases/download/${RUSTNET_VERSION}/${DMG_NAME}" -o "$DMG_NAME"

    MOUNT_POINT="/tmp/RustNetInstall-${RUSTNET_VERSION}-${ARCH}"
    rm -rf "$MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"

    if ! hdiutil attach "$DMG_NAME" -nobrowse -mountpoint "$MOUNT_POINT" >/tmp/rustnet-attach.log 2>&1; then
        echo "[FAIL ❌] Failed to mount $DMG_NAME"
        echo "$(cat /tmp/rustnet-attach.log)"
        clean_up
        rm -rf "$MOUNT_POINT"
        exit 1
    fi

    if [[ ! -d "$MOUNT_POINT/Rustnet.app" ]]; then
        echo "[FAIL ❌] Mounted DMG but Rustnet.app was not found in $MOUNT_POINT"
        hdiutil detach "$MOUNT_POINT" -quiet >/dev/null 2>&1 || true
        clean_up
        rm -rf "$MOUNT_POINT"
        exit 1
    fi

    echo "[INFO] Copying Rustnet.app to /Applications"
    sudo rm -rf "/Applications/Rustnet.app"
    sudo cp -R "$MOUNT_POINT/Rustnet.app" "/Applications/"
    hdiutil detach "$MOUNT_POINT" -quiet >/dev/null 2>&1 || true
    rm -rf "$MOUNT_POINT"
    clean_up

    sudo mkdir -p /usr/local/bin
    sudo ln -sf /Applications/Rustnet.app/Contents/MacOS/rustnet /usr/local/bin/rustnet
}

install_linux() {
    echo "[INSTALLING ⬇️] Rustnet on Linux"
    wget "https://github.com/domcyrus/rustnet/releases/download/${RUSTNET_VERSION}/Rustnet_LinuxDEB_amd64.deb"
    sudo dpkg -i Rustnet_LinuxDEB_amd64.deb
    clean_up
}

if ! command -v rustnet &>/dev/null; then
    if [[ "$OS" == "darwin" ]]; then
        install_macos
    else
        install_linux
    fi

    if ! command -v rustnet &>/dev/null; then
        echo "[FAIL ❌] rustnet installation failed!"
        echo "If you're on macOS, you may need to open /Applications/Rustnet.app once to bypass Gatekeeper."
        exit 1
    fi

    echo "[CHECKED ✅] rustnet command installed!"
else
    echo "[CHECKED ✅] rustnet command exists"
fi