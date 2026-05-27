#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "$TARBALL"
}

GO_VERSION="1.24.5"

if ! go version &>/dev/null; then
    echo "[INSTALLING ⬇️] Go ${GO_VERSION}"
    TARBALL="go${GO_VERSION}.${OS}-${ARCH}.tar.gz"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://go.dev/dl/${TARBALL}" -o "$TARBALL"

    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$TARBALL"

    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
    clean_up

    export GOROOT=/usr/local/go

    if ! go version &>/dev/null; then
        echo "[FAIL ❌] go installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] go command installed!"
else
    echo "[CHECKED ✅] go command exists"
fi