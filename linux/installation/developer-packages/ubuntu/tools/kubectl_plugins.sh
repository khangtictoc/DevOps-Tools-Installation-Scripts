#!/usr/bin/env bash

# Note: Remember to "export SHELL_PROFILE", e.g. '$HOME/.zshrc' or '$HOME/.bashrc'

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -rf "LICENSE" "${KREW}" "${KREW}.tar.gz"
}

# --- Install Krew -----------------------------------------------

if ! kubectl krew version &>/dev/null; then

    KREW="krew-${OS}_${ARCH}"

    echo "[INSTALLING ⬇️] Krew"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" \
        -o "${KREW}.tar.gz"
    tar zxf "${KREW}.tar.gz"
    ./"${KREW}" install krew
    clean_up

    echo "[INFO] Adding Krew to PATH..."
    EXPORT_KREW_PATH='export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"'
    if grep -Fxq "$EXPORT_KREW_PATH" "$SHELL_PROFILE"; then
        echo "✅ Krew PATH already set. No changes."
    else
        echo "$EXPORT_KREW_PATH" >> "$SHELL_PROFILE"
        echo "✅ Krew binary added to PATH!"
    fi

    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

    if ! kubectl krew version &>/dev/null; then
        echo "[FAIL ❌] krew installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] krew installed!"
else
    echo "[CHECKED ✅] krew already exists"
fi

# --- Krew Plugins -----------------------------------------------

echo "[INSTALLING ⬇️] kubectl plugins"
kubectl krew install tree
kubectl krew install view-secret

# --- kubectl-node-shell -----------------------------------------

if ! command -v kubectl-node_shell &>/dev/null; then

    echo "[INSTALLING ⬇️] kubectl-node-shell"
    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell" \
        -o kubectl-node_shell
    sudo chmod +x kubectl-node_shell
    sudo mv kubectl-node_shell /usr/local/bin/kubectl-node_shell

    if ! command -v kubectl-node_shell &>/dev/null; then
        echo "[FAIL ❌] kubectl-node-shell installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] kubectl-node-shell installed!"
else
    echo "[CHECKED ✅] kubectl-node-shell already exists"
fi

# --- Confirm ----------------------------------------------------

echo "[INFO] Installed plugins:"
kubectl plugin list