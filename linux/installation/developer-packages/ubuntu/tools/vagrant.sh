#! /bin/bash

if ! command -v vagrant &> /dev/null
then
    echo "[INSTALLING ⬇️ ] Vagrant"
    wget \
        -O - https://apt.releases.hashicorp.com/gpg \
        | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update && sudo apt install -y vagrant

    # ✅ Use env var flag; fall back to interactive prompt if not set
    if [ -z "$INSTALL_VAGRANT_PLUGINS" ]
    then
        read -p "Do you want to install Vagrant Plugins? (y/n): " CONFIRM  # ✅ fixed: store into $CONFIRM
    else
        CONFIRM="$INSTALL_VAGRANT_PLUGINS"
    fi

    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]
    then
        vagrant plugin install vagrant-vmware-desktop
        echo "[CHECKED ✅] vagrant plugins installed!"
    else
        echo "[INFO] Skipping Vagrant plugins installation."
    fi

    echo "[CHECKED ✅] vagrant command installed!"
else
    echo "[CHECKED ✅] vagrant command exists"
fi