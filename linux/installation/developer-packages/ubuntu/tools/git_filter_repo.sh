#!/usr/bin/env bash

if ! command -v git-filter-repo &>/dev/null; then
    echo "[INSTALLING ⬇️] git-filter-repo"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo \
        -o git-filter-repo
    sudo chmod +x git-filter-repo
    sudo mv git-filter-repo /usr/local/bin/

    if ! command -v git-filter-repo &>/dev/null; then
        echo "[FAIL ❌] git-filter-repo installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] git-filter-repo command installed!"
else
    echo "[CHECKED ✅] git-filter-repo command exists"
fi