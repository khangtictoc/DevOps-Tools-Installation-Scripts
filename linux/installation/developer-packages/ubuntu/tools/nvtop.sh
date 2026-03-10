#!/usr/bin/env bash

if ! command -v nvtop &>/dev/null; then
    echo "[INSTALLING ⬇️] nvtop"

    case "$(uname -s)" in
        Darwin)
            brew install nvtop
            ;;
        Linux)
            sudo apt update
            if ! sudo apt install -y nvtop 2>/dev/null; then
                echo "[INFO] nvtop not found in default repo, adding PPA..."
                sudo add-apt-repository -y ppa:quentiumyt/nvtop
                sudo apt update
                sudo apt install -y nvtop
            fi
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v nvtop &>/dev/null; then
        echo "[FAIL ❌] nvtop installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] nvtop command installed!"
else
    echo "[CHECKED ✅] nvtop command exists"
fi