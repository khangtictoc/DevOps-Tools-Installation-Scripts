#!/usr/bin/env bash

NODEJS_VERSION=22

if ! command -v node &>/dev/null; then
    echo "[INSTALLING ⬇️] Node.js v${NODEJS_VERSION} (via nvm)"

    # Force nvm to install to ~/.nvm regardless of XDG config
    export NVM_DIR="$HOME/.nvm"
    unset XDG_CONFIG_HOME

    curl -fsSL --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 \
        https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install ${NODEJS_VERSION}

    if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
        echo "[FAIL ❌] node installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] node command installed!"
else
    echo "[CHECKED ✅] node command exists"
fi