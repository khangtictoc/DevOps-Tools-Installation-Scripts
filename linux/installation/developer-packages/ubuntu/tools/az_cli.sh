#!/bin/bash

if ! command -v az 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] Azure CLI"
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    # Extract major version number
    MAJOR_VERSION=$(echo $VERSION_ID | cut -d. -f1)
else
    echo "Cannot detect OS"
    exit 1
fi

# Install Azure CLI based on OS
if [[ "$OS" == *"Red Hat"* ]]; then
    if [ "$MAJOR_VERSION" == "8" ]; then
        echo "Installing Azure CLI for RHEL 8..."
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
        dnf install azure-cli
    elif [ "$MAJOR_VERSION" == "9" ]; then
        echo "Installing Azure CLI for RHEL 9..."
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
        dnf install -y azure-cli
    else
        echo "Unsupported RHEL version"
        exit 1
    fi
elif [[ "$OS" == *"Ubuntu"* ]]; then
    echo "Installing Azure CLI for Ubuntu..."
    curl  -sL https://aka.ms/InstallAzureCLIDeb | bash
else
    echo "Unsupported OS: $OS"
    exit 1
fi

    echo "Azure CLI installation completed"

    if ! command -v az &> /dev/null; then
        echo "[FAIL ❌] az installation failed!"
        exit 1
    fi
    
    echo "[CHECKED ✅] az command installed!"
else
    echo "[CHECKED ✅] az command exists"
fi