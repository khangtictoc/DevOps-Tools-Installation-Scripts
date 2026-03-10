#! /bin/bash

GO_VERSION=1.24.5

if ! go version &> /dev/null
then
    echo "[INSTALLING ⬇️ ] Go"
    wget "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    
    sudo rm -rf /usr/local/go  # remove any previous install
    sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz  # extract full toolchain
    
    # symlink the binary so it's on PATH
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt

    echo "[INFO] >>>> Clean Up"
    rm -f go$GO_VERSION.linux-amd64.tar.gz  # only remove the tarball

    export GOROOT=/usr/local/go  # set for current session

    if ! go version &> /dev/null; then
        echo "[FAIL ❌] go installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] go command installed!"
else
    echo "[CHECKED ✅] go command exists"
fi