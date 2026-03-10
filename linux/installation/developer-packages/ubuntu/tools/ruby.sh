#!/usr/bin/env bash

RUBY_VERSION="3.4.4"

if ! command -v ruby &>/dev/null; then
    echo "[INSTALLING ⬇️] Ruby v${RUBY_VERSION} (via rbenv)"

    # Clone rbenv if not already present
    if [ ! -d "$HOME/.rbenv" ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(~/.rbenv/bin/rbenv init -)"

    # Clone ruby-build plugin if not already present
    if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
        git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
    else
        git -C "$(rbenv root)/plugins/ruby-build" pull
    fi

    # Install build dependencies
    case "$(uname -s)" in
        Darwin)
            brew install openssl libyaml libffi gmp rust
            ;;
        Linux)
            sudo apt-get update
            sudo apt-get install -y \
                build-essential autoconf \
                libssl-dev libyaml-dev zlib1g-dev \
                libffi-dev libgmp-dev rustc
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

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