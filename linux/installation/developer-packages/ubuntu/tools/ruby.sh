#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

RUBY_VERSION="3.4.4"

if ! command -v ruby &>/dev/null; then
    echo "[INSTALLING ⬇️] Ruby v${RUBY_VERSION} (via rbenv)"

    # Clone rbenv if not already present
    if [ ! -d "$HOME/.rbenv" ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(~/.rbenv/bin/rbenv init -)"

    # Clone ruby-build plugin if not present
    if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
        git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
    else
        git -C "$(rbenv root)/plugins/ruby-build" pull
    fi

    # Install build dependencies
    if [[ "$PKG_MGMT" == "brew" ]]; then
        brew install openssl libyaml libffi gmp rust
    else
        sudo apt-get update
        sudo apt-get install -y \
            build-essential autoconf \
            libssl-dev libyaml-dev zlib1g-dev \
            libffi-dev libgmp-dev rustc
    fi

    rbenv install -s "$RUBY_VERSION"
    rbenv global "$RUBY_VERSION"

    if ! command -v ruby &>/dev/null; then
        echo "[FAIL ❌] ruby installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] ruby command installed!"
else
    echo "[CHECKED ✅] ruby command exists"
fi