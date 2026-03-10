#!/usr/bin/env bash

MONGO_CLI_VERSION="100.12.2"
MONGOSH_CLI_VERSION="8.0"

if ! command -v mongodump &>/dev/null || ! command -v mongosh &>/dev/null; then
    echo "[INSTALLING ⬇️] MongoDB CLI Tools"

    case "$(uname -s)" in
        Darwin)
            brew tap mongodb/brew
            brew install mongodb-database-tools
            brew install mongosh
            ;;
        Linux)
            ARCH="$(uname -m)"
            UBUNTU_VERSION="$(lsb_release -rs | tr -d '.')"
            source /etc/os-release
            OS_CODENAME="${ID}${UBUNTU_VERSION}"

            # MongoDB Database Tools
            DEB="mongodb-database-tools-${OS_CODENAME}-${ARCH}-${MONGO_CLI_VERSION}.deb"
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://fastdl.mongodb.org/tools/db/${DEB}" -o "$DEB"
            sudo dpkg -i "$DEB"
            rm -f "$DEB"

            # MongoDB Shell (mongosh)
            curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://www.mongodb.org/static/pgp/server-${MONGOSH_CLI_VERSION}.asc" \
                | sudo tee /etc/apt/trusted.gpg.d/server-${MONGOSH_CLI_VERSION}.asc > /dev/null
            echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/${MONGOSH_CLI_VERSION} multiverse" \
                | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGOSH_CLI_VERSION}.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y mongodb-mongosh
            ;;
        *)
            echo "[ERROR] Unsupported OS"; exit 1
            ;;
    esac

    if ! command -v mongodump &>/dev/null; then
        echo "[FAIL ❌] mongodb-database-tools installation failed!"
        exit 1
    fi
    echo "[CHECKED ✅] MongoDB CLI tools installed! Try 'mongodump', 'mongorestore', ..."

    if ! command -v mongosh &>/dev/null; then
        echo "[FAIL ❌] mongosh installation failed!"
        exit 1
    fi
    echo "[CHECKED ✅] mongosh installed!"
else
    echo "[CHECKED ✅] mongosh + MongoDB CLI tools already exist"
fi