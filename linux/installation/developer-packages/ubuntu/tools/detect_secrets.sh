#!/usr/bin/env bash

DETECT_SECRETS_VERSION="1.5.0"

if ! command -v detect-secrets &>/dev/null; then
    echo "[INSTALLING ⬇️] detect-secrets"

    pip3 install detect-secrets==${DETECT_SECRETS_VERSION}

    if ! command -v detect-secrets &>/dev/null; then
        echo "[FAIL ❌] detect-secrets installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] detect-secrets command installed!"
else
    echo "[CHECKED ✅] detect-secrets command exists"
fi