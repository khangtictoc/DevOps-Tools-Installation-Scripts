#!/usr/bin/env bash

source <(curl -sS "https://raw.githubusercontent.com/khangtictoc/Productive-Workspace-Set-Up/refs/heads/main/linux/utility/library/bash/detect_os.sh")
detect_os

clean_up() {
    echo "[INFO] Clean up"
    rm -f "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
}

MAVEN_VERSION="3.9.13"

if ! mvn --version &>/dev/null; then
    echo "[INSTALLING ⬇️] Maven v${MAVEN_VERSION}"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
        -o "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
    tar -xzf "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
    sudo mv "apache-maven-${MAVEN_VERSION}" /opt/maven
    sudo ln -sf /opt/maven/bin/mvn /usr/local/bin/mvn

    if [[ "$OS" == "darwin" ]]; then
        export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    else
        export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    fi

    export M2_HOME=/opt/maven
    export PATH="$M2_HOME/bin:$PATH"
    clean_up

    if ! mvn --version &>/dev/null; then
        echo "[FAIL ❌] Maven installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] Maven installed! Try 'mvn -v'"
else
    echo "[CHECKED ✅] Maven already installed! Try 'mvn -v'"
fi