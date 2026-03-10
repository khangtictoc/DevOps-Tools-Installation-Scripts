#! /bin/bash

# Note: Remember to "export $SHELLRC_FILE", i.e '$HOME/.bashrc'. Depend on your favorite shell

# Install 'Krew'

## Get Info
echo "[INFO] Determine System Info"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
KREW="krew-${OS}_${ARCH}"

## Download and Install
echo "[INFO] Downloading Krew ..."
wget "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
tar zxvf "${KREW}.tar.gz"
./"${KREW}" install krew
echo "[INFO] Clean Up ..."
rm -drf "LICENSE" "${KREW}" "${KREW}.tar.gz"

## Finalize Installation
echo "[INFO] Add to Path"
EXPORT_KREW_PATH='export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"'
if grep -Fxq "$EXPORT_KREW_PATH" "$SHELLRC_FILE"; then
    echo "✅ Krew binary has been added to PATH! No changes"
else
    echo "$EXPORT_KREW_PATH" >> "$SHELLRC_FILE"
    echo "✅ Krew binary has been added to PATH!"
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

##  [Plugin] kubectl krew - Install useful plugins
echo "====== Install Useful plugins ====="
echo "[INFO] Installing tree ..."
kubectl krew install tree
echo "[INFO] Installing View-Secret ..."
kubectl krew install view-secret

## [Plugin] Kubectl Node Shell
echo "[INFO] Installing Node Shell ..."
wget https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell
sudo chmod +x ./kubectl-node_shell
sudo mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell

if ! kubectl krew &> /dev/null
then
    echo "[FAIL ❌] kubectl krew installation failed!"
    exit 1
fi

echo "[CHECKED ✅] kubectl krew command installed!"

if ! kubectl plugin list &> /dev/null
then
    echo "[FAIL ❌] kubectl krew installation failed!"
    exit 1
fi

echo "[CHECKED ✅] kubectl plugins command installed!"

echo "[INFO] Confirm your plugins"
kubectl plugin list


