#!/usr/bin/env bash

if ! command -v az &>/dev/null; then
    echo "[INSTALLING ⬇️] Azure CLI"

    case "$(uname -s)" in
        Darwin)
            brew install azure-cli
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
                        ;;
                    rhel)
                        MAJOR_VERSION=$(echo "$VERSION_ID" | cut -d. -f1)
                        rpm --import https://packages.microsoft.com/keys/microsoft.asc
                        if [ "$MAJOR_VERSION" == "8" ]; then
                            dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
                        elif [ "$MAJOR_VERSION" == "9" ]; then
                            dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
                        else
                            echo "[ERROR] Unsupported RHEL version: $MAJOR_VERSION"
                            exit 1
                        fi
                        dnf install -y azure-cli
                        ;;
                    *)
                        echo "[ERROR] Unsupported Linux distro: $ID"
                        exit 1
                        ;;
                esac
            else
                echo "[ERROR] Cannot detect OS"
                exit 1
            fi
            ;;
        *)
            echo "[ERROR] Unsupported OS"
            exit 1
            ;;
    esac

    if ! command -v az &>/dev/null; then
        echo "[FAIL ❌] az installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] az command installed!"
else
    echo "[CHECKED ✅] az command exists"
fi