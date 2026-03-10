#!/bin/bash

# Install perf - Linux profiling with performance counters
# Installation: https://github.com/microsoft/WSL2-Linux-Kernel/tree/linux-msft-wsl-6.6.y

IS_WSL=$(grep -i WSL /proc/version > /dev/null 2>&1; echo $?)

if ! perf -h &> /dev/null
then
    if [ "$IS_WSL" -eq 0 ]
    then
        echo "Detected WSL environment. Installing perf may require additional steps."

        sudo apt install -y \
            build-essential \
            flex \
            bison \
            dwarves \
            libssl-dev \
            libelf-dev \
            cpio qemu-utils

        KERNEL_VERSION=$(uname -r | cut -d'-' -f1)
        git clone \
            --depth 1 \
            --single-branch \
            --branch=linux-msft-wsl-${KERNEL_VERSION} \
            https://github.com/microsoft/WSL2-Linux-Kernel.git \
            ~/WSL2-Linux-Kernel
        
        cd ~/WSL2-Linux-Kernel
        make -j $(nproc) KCONFIG_CONFIG=Microsoft/config-wsl && make INSTALL_MOD_PATH="$PWD/modules" modules_install
        cd tools/perf
        make
        sudo cp perf /usr/bin/

        echo "[INFO] >>>> Clean Up"
        cd ../../..
        rm -drf WSL2-Linux-Kernel

        if ! perf -h &> /dev/null; then
            echo "perf installation failed in WSL environment."
            exit 1
        fi

        echo "[CHECKED ✅] perf command installed!"
    else
        echo "Non-WSL environment detected."
        echo "perf could not be found, installing..."
        sudo apt update
        sudo apt install -y linux-tools-common linux-tools-$(uname -r)

        if ! perf -h &> /dev/null; then
            echo "[FAIL ❌] perf installation failed!"
            exit 1
        fi

        echo "[CHECKED ✅] perf command installed!"
    fi
    
else
    echo "[CHECKED ✅] perf command exists"
fi