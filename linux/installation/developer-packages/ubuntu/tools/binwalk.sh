#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

if ! command -v binwalk &>/dev/null; then
  case "$OS" in
  linux)
    echo "✓ Detected Linux - Installing 'binwalk' dependencies with Cargo ..."
    sudo apt update
    sudo apt install -y build-essential libfontconfig1-dev liblzma-dev
    cargo install binwalk

    if ! binwalk -h &>/dev/null; then
      echo "[FAIL ❌] binwalk installation failed!"
      exit 1
    fi

    echo "[CHECKED ✅] binwalk command installed!"
    ;;
  darwin)
    echo "[FAIL ❌] macOS is not compatible. Binwalk installation failed!"
    exit 1
    ;;
  *)
    echo "[FAIL ❌] Unknown OS. Binwalk installation failed!"
    exit 1
    ;;
  esac
else
  echo "[CHECKED ✅] binwalk is already installed!"
fi