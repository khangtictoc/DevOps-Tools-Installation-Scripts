#! /bin/bash

MONGO_CLI_VERSION=100.12.2
MONGOSH_CLI_VERSION=8.0

if ! command -v mongo 2>&1 >/dev/null || ! command -v mongosh 2>&1 >/dev/null
then
    echo "[INFO] Get System OS Info"
    ARCH="$(uname -m)"
    UBUNTU_VERSION="$(lsb_release -rs | tr -d '.')"
    source /etc/os-release
    OS_CODENAME="$ID$UBUNTU_VERSION"

    echo "[INSTALLING ⬇️ ] MongoDB CLI Tools"
    ## MongoDB Database Tools
    wget "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-$OS_CODENAME-$ARCH-$MONGO_CLI_VERSION.deb"
    sudo dpkg -i mongodb-database-tools-$OS_CODENAME-$ARCH-$MONGO_CLI_VERSION.deb
    
    echo "[INFO] >>>> Clean Up"
    rm -f mongodb-database-tools-$OS_CODENAME-$ARCH-$MONGO_CLI_VERSION.deb

    ## MongoDB Shell (mongosh)
    wget -qO- https://www.mongodb.org/static/pgp/server-$MONGOSH_CLI_VERSION.asc \
        | sudo tee /etc/apt/trusted.gpg.d/server-$MONGOSH_CLI_VERSION.asc
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/$MONGOSH_CLI_VERSION multiverse" \
        | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGOSH_CLI_VERSION.list
    sudo apt-get update
    sudo apt-get install -y mongodb-mongosh

    if ! command -v mongodump &> /dev/null &> /dev/null; then
        echo "[FAIL ❌] mongo installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] Set of mongo commands installed! Try 'mongodump', 'mongorestore', ..."

    if ! command -v mongosh &> /dev/null; then
        echo "[FAIL ❌] mongosh installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] mongosh command installed!"
else
    echo "[CHECKED ✅] mongosh + set of mongo commands exists!. Try 'mongodump', 'mongorestore', ..."
fi