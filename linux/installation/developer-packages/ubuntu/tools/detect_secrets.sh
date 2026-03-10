#! /bin/bash

DETECT_SECRETS_VERSION="1.5.0"

if ! command -v detect-secrets 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] detect-secrets"
    echo "==== INSTALLING detect-secrets ===="
    wget "https://codeload.github.com/Yelp/detect-secrets/zip/refs/tags/v${DETECT_SECRETS_VERSION}" -O detect-secrets.zip
    unzip detect-secrets.zip
    cd detect-secrets-${DETECT_SECRETS_VERSION}
    pip install setuptools
    sudo python3 setup.py install
    
    echo "[INFO] >>>> Clean Up"
    cd .. && rm -rf detect-secrets-${DETECT_SECRETS_VERSION} detect-secrets.zip

    if ! command -v detect-secrets &> /dev/null; then
        echo "[FAIL ❌] detect-secrets installation failed!"
        exit 1
    fi
    echo "[CHECKED ✅] detect-secrets command installed!"
else
    echo "[CHECKED ✅] detect-secrets command exists"
fi