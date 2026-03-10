#! /bin/bash

if ! command -v ansi 2>&1 >/dev/null
then
    wget git.io/ansi
    sudo chmod 755 ansi
    sudo mv ansi /usr/local/bin/

    if ! command -v ansi &> /dev/null; then
        echo "[FAIL ❌] ansi installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ansi command installed!"
else
    echo "[CHECKED ✅] ansi command exists"
fi