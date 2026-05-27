#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

TESTDISK_VERSION="7.3"

# Linux
URL_LINUX="https://www.cgsecurity.org/testdisk-${TESTDISK_VERSION}-WIP.linux26-x86_64.tar.bz2"
DIR_LINUX="testdisk-${TESTDISK_VERSION}-WIP"

# MacOS Intel
URL_MAC="https://www.cgsecurity.org/testdisk-${TESTDISK_VERSION}.mac_intel_x86_64.tar.bz2"
DIR_MAC="testdisk-${TESTDISK_VERSION}"

clean_up() {
  echo "[INFO] Clean up"
  rm -f "$archive"
}

main_install() {
  local url=$1
  local dir=$2
  local archive="testdisk_download.tar.bz2"
  local install_path="/opt/testdisk_tools"

  echo "--- Downloading and Extracting ---"
  wget -q --show-progress "$url" -O "$archive"
  tar -xvjf "$archive"

  # 1. Chuyển nguyên thư mục vào /opt
  sudo rm -rf "$install_path"
  sudo mv "$dir" "$install_path"

  # 2. Tạo Wrapper Script cho từng lệnh
  echo "--- Creating Wrapper Scripts ---"
  
  local suffix=""
  [[ "$OS" == "linux" ]] && suffix="_static"

  # Tạo hàm helper để viết wrapper
  create_wrapper() {
    local cmd_name=$1
    local binary_name=$2
    
    # Tạo file thực thi ngắn gọn
    sudo bash -c "cat > /usr/local/bin/$cmd_name" <<EOF
#!/bin/bash
cd $install_path && ./$binary_name "\$@"
EOF
    sudo chmod +x "/usr/local/bin/$cmd_name"
  }

  create_wrapper "testdisk" "testdisk$suffix"
  create_wrapper "photorec" "photorec$suffix"
  create_wrapper "fidentify" "fidentify$suffix"

  clean_up
}

if ! command -v testdisk &>/dev/null; then
  case "$OS" in
  linux)
    echo "✓ Detected Linux - Installing Linux binaries..."
    main_install "$URL_LINUX" "$DIR_LINUX"
    ;;
  darwin)
    echo "✓ Detected macOS - Installing Mac Intel binaries..."
    main_install "$URL_MAC" "$DIR_MAC"
    ;;
  *)
    echo "[FAIL ❌] Unsupported OS: $OS. Installation failed!"
    exit 1
    ;;
  esac

  # Kiểm tra kết quả cuối cùng
  if testdisk -v &>/dev/null; then
    echo "[CHECKED ✅] testdisk, photorec, and fidentify installed successfully!"
  else
    echo "[FAIL ❌] Installation failed at verification step!"
    exit 1
  fi
else
  echo "[CHECKED ✅] TestDisk is already installed!"
fi