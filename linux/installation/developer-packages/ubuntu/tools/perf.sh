#!/usr/bin/env bash

# perf - Linux profiling with performance counters
# WSL install reference: https://github.com/microsoft/WSL2-Linux-Kernel/tree/linux-msft-wsl-6.6.y

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "[SKIP] perf is Linux-only. Skipping on $(uname -s)."
    exit 0
fi

IS_WSL=false
grep -qi "microsoft" /proc/version 2>/dev/null && IS_WSL=true

if ! perf -h &>/dev/null; then

    if [[ "$IS_WSL" == true ]]; then
        echo "[INFO] WSL environment detected. Building perf from source..."

        sudo apt install -y \
            build-essential flex bison dwarves \
            libssl-dev libelf-dev cpio qemu-utils

        KERNEL_VERSION=$(uname -r | cut -d'-' -f1)

        (
            git clone \
                --depth 1 \
                --single-branch \
                --branch "linux-msft-wsl-${KERNEL_VERSION}" \
                https://github.com/microsoft/WSL2-Linux-Kernel.git \
                ~/WSL2-Linux-Kernel

            cd ~/WSL2-Linux-Kernel
            make -j "$(nproc)" KCONFIG_CONFIG=Microsoft/config-wsl
            make INSTALL_MOD_PATH="$PWD/modules" modules_install

            cd tools/perf
            make
            sudo cp perf /usr/bin/
        )

        echo "[INFO] Clean up"
        rm -rf ~/WSL2-Linux-Kernel

    else
        echo "[INFO] Non-WSL Linux detected. Installing perf via apt..."
        sudo apt update
        sudo apt install -y linux-tools-common "linux-tools-$(uname -r)"
    fi

    if ! perf -h &>/dev/null; then
        echo "[FAIL ❌] perf installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] perf command installed!"
else
    echo "[CHECKED ✅] perf command exists"
fi