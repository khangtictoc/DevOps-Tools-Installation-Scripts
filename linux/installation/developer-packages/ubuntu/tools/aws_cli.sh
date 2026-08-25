#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/get_os.sh")

clean_up() {
    echo "[INFO] Clean up"
    rm -f awscliv2.zip
    rm -f AWSCLIV2.pkg
    rm -rf aws
    rm -f session-manager-plugin.deb
}

detect_aws_url() {
    local aws_os aws_arch
    case "$OS" in
        darwin) aws_os="macos" ;;
        linux)  aws_os="linux" ;;
    esac
    case "$ARCH" in
        amd64) aws_arch="x86_64"  ;;
        arm64) aws_arch="aarch64" ;;
    esac
    echo "https://awscli.amazonaws.com/awscli-exe-${aws_os}-${aws_arch}.zip"
}


# --- AWS Plugins ---------------------------------------


install_ssm() {
    if ! command -v session-manager-plugin &>/dev/null; then
        echo "[INSTALLING PLUGIN] SSM (Session Manager)"
        curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
        sudo dpkg -i session-manager-plugin.deb

        if ! command -v session-manager-plugin &>/dev/null; then
            echo "[FAIL ❌] SSM Plugin installation failed!"
            exit 1
        fi
        
        echo "[CHECKED ✅] SSM Plugin command installed!"

    else
        echo "[CHECKED ✅] SSM Plugin command exists!"
    fi
}

install_plugin() {
    install_ssm
}

install_main() {
    if ! command -v aws &>/dev/null; then
        echo "[INSTALLING ⬇️] AWS CLI"
        if [ "$OS" = "darwin" ]; then
            # Use the official macOS installer package for AWS CLI v2
            URL="https://awscli.amazonaws.com/AWSCLIV2.pkg"
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "$URL" -o AWSCLIV2.pkg
            sudo installer -pkg AWSCLIV2.pkg -target /
            rm -f AWSCLIV2.pkg
        else
            URL=$(detect_aws_url)

            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "$URL" -o awscliv2.zip

            echo "[INFO ℹ️] Extracting zipped files"

            unzip -q awscliv2.zip
            sudo ./aws/install
        fi

        if ! command -v aws &>/dev/null; then
            echo "[FAIL ❌] aws installation failed!"
            exit 1
        fi

        echo "[CHECKED ✅] aws command installed!"
    else
        echo "[CHECKED ✅] aws command exists!"
    fi
}

install_main
install_plugin
clean_up