#!/usr/bin/env bash

ANSIBLE_VERSION="6.7.0"

# Note: Remember to "export SHELLRC_FILE", e.g. '$HOME/.zshrc' or '$HOME/.bashrc'

if ! command -v ansible &>/dev/null; then
    pip3 install ansible==$ANSIBLE_VERSION

    # Add "$HOME/.local/bin" to PATH
    if ! grep -Fxq 'export PATH="$HOME/.local/bin:$PATH"' "${SHELLRC_FILE}"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "${SHELLRC_FILE}"
        echo "[INFO] Update: Added \$HOME/.local/bin to PATH"
    else
        echo "[INFO] Existed: \$HOME/.local/bin already in PATH"
    fi

    export PATH="$HOME/.local/bin:$PATH"

    if command -v ansible &>/dev/null; then
        echo "[FAIL ❌] ansible installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ansible installed! Reload shell to see changes"
else
    echo "[CHECKED ✅] ansible already exists"
fi