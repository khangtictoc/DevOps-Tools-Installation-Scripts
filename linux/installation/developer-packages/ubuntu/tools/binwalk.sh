#! /bin/bash

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if it's Ubuntu
    if grep -qi ubuntu /etc/os-release 2>/dev/null; then
      echo "Ubuntu"
    else
      echo "Linux"
    fi
  else
    echo "Unknown"
  fi
}

OS=$(detect_os)

if ! command -v binwalk &>/dev/null; then
    case "$OS" in
    Ubuntu)
        echo "✓ Detected Ubuntu - Installing 'binwalk' dependencies with Cargo ..."
        main_install

        if ! binwalk -h &>/dev/null; then
            echo "[FAIL ❌] binwalk installation failed!"
            exit 1
        fi

        echo "[CHECKED ✅] binwalk command installed!"
        ;;
    macOS)
        echo "[FAIL ❌] MacOS is not compatible. Binwalk installation failed!"
        ;;
    *)
        echo "[FAIL ❌] Unknown OS. Binwalk installation failed!"
        ;;
    esac
else

function main_install(){
    sudo apt update
    sudo apt install -y build-essential libfontconfig1-dev liblzma-dev
    cargo install binwalk
}