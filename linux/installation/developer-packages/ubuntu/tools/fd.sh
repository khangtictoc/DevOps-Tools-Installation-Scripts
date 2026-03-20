#! /bin/bash

if ! command -v fd 2>&1 >/dev/null
then
    sudo apt-get -y install fd-find
    ln -s $(which fdfind) ~/.local/bin/fd

    if ! command -v fd &> /dev/null; then
        echo "[FAIL ❌] fd installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] fd command installed!"
else
    echo "[CHECKED ✅] fd command exists"
fi