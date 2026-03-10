#! /bin/bash

# Note: Remember to "export $SHELLRC_FILE", i.e '$HOME/.bashrc'. Depend on your favorite shell

source /etc/os-release

if ! command -v sqlcmd 2>&1 >/dev/null
then
    echo "[INSTALLING ⬇️ ] SQL Server Command Line Tools"
    curl  https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
    curl  https://packages.microsoft.com/config/ubuntu/$VERSION_ID/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
    
    sudo apt-get update
    sudo apt-get install -y \
    mssql-tools18 \
    unixodbc-dev

    if ! grep -Fxq 'export PATH="$PATH:/opt/mssql-tools18/bin"' ${SHELLRC_FILE}; then
        echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> "$SHELLRC_FILE"
        echo -e "[INFO] Update: Add binary for MSSQL as executable path to PATH"
    else
        echo -e "[INFO] Already add binary for MSSQL as executable path to PATH"
    fi

    export PATH="$PATH:/opt/mssql-tools18/bin"

    if ! command -v sqlcmd &> /dev/null; then
        echo "[FAIL ❌] sqlcmd installation failed!"
        exit 1
    fi
    
    echo "[CHECKED ✅] sqlcmd command installed!"
else
    echo "[CHECKED ✅] sqlcmd command exists"
fi