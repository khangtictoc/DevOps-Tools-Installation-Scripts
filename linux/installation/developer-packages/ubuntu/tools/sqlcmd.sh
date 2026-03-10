#!/usr/bin/env bash

# Note: Remember to "export SHELLRC_FILE", e.g. '$HOME/.zshrc' or '$HOME/.bashrc'

if ! command -v sqlcmd &>/dev/null; then
    echo "[INSTALLING ⬇️] SQL Server Command Line Tools"

    case "$(uname -s)" in
        Darwin)
            brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
            brew update
            HOMEBREW_ACCEPT_EULA=Y brew install mssql-tools18 msodbcsql18
            ;;
        Linux)
            source /etc/os-release
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL https://packages.microsoft.com/keys/microsoft.asc \
                | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc >/dev/null
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/prod.list" \
                | sudo tee /etc/apt/sources.list.d/mssql-release.list >/dev/null
            sudo apt-get update
            sudo apt-get install -y mssql-tools18 unixodbc-dev

            if ! grep -Fxq 'export PATH="$PATH:/opt/mssql-tools18/bin"' "${SHELLRC_FILE}"; then
                echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> "$SHELLRC_FILE"
                echo "[INFO] Update: Added mssql-tools18 binary to PATH"
            else
                echo "[INFO] Existed: mssql-tools18 binary already in PATH"
            fi

            export PATH="$PATH:/opt/mssql-tools18/bin"
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v sqlcmd &>/dev/null; then
        echo "[FAIL ❌] sqlcmd installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] sqlcmd command installed!"
else
    echo "[CHECKED ✅] sqlcmd command exists"
fi