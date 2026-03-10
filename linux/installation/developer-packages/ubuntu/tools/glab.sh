#!/usr/bin/env bash

GLAB_VERSION="1.67.0"

if ! command -v glab &>/dev/null; then
    echo "[INSTALLING ⬇️] GitLab CLI"

    case "$(uname -s)" in
        Darwin)
            brew install glab
            ;;
        Linux)
            case "$(uname -m)" in
                x86_64)          arch="amd64" ;;
                arm64 | aarch64) arch="arm64" ;;
                *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
            esac

            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_${arch}.deb" \
                -o "glab_${GLAB_VERSION}_linux_${arch}.deb"
            sudo dpkg -i "glab_${GLAB_VERSION}_linux_${arch}.deb"

            echo "[INFO] Clean up"
            rm "glab_${GLAB_VERSION}_linux_${arch}.deb"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v glab &>/dev/null; then
        echo "[FAIL ❌] glab installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] glab command installed!"
else
    echo "[CHECKED ✅] glab command exists"
fi