#!/usr/bin/env bash

GO_VERSION="1.24.5"

detect_go_platform() {
    case "$(uname -s)" in
        Darwin) os="darwin" ;;
        Linux)  os="linux"  ;;
        *) echo "[ERROR] Unsupported OS"; exit 1 ;;
    esac

    case "$(uname -m)" in
        x86_64)          arch="amd64" ;;
        arm64 | aarch64) arch="arm64" ;;
        *) echo "[ERROR] Unsupported architecture"; exit 1 ;;
    esac

    echo "go${GO_VERSION}.${os}-${arch}.tar.gz"
}

if ! go version &>/dev/null; then
    echo "[INSTALLING ⬇️] Go ${GO_VERSION}"
    TARBALL=$(detect_go_platform)

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://go.dev/dl/${TARBALL}" -o "$TARBALL"

    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$TARBALL"

    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt

    echo "[INFO] Clean up"
    rm -f "$TARBALL"

    export GOROOT=/usr/local/go

    if ! go version &>/dev/null; then
        echo "[FAIL ❌] go installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] go command installed!"
else
    echo "[CHECKED ✅] go command exists"
fi