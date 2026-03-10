#! /bin/bash

NODEJS_VERSION=22

if ! command -v node 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Node.js"

    # Download and install nvm:
    curl  -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install ${NODEJS_VERSION}

    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        echo "[FAIL ❌] node installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] node command installed!"
else
    echo "[CHECKED ✅] node command exists"
fi