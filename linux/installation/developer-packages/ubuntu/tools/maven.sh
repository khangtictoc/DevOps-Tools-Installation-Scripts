#!/usr/bin/env bash

MAVEN_VERSION="3.9.13"

if ! mvn --version &>/dev/null; then
    echo "[INSTALLING ⬇️] Maven v${MAVEN_VERSION}"

    curl --retry 3 --retry-delay 5 --connect-timeout 30 --max-time 120 -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
        -o "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
    tar -xzf "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
    sudo mv "apache-maven-${MAVEN_VERSION}" /opt/maven
    sudo ln -sf /opt/maven/bin/mvn /usr/local/bin/mvn

    # JAVA_HOME: macOS and Ubuntu resolve differently
    if [[ "$(uname -s)" == "Darwin" ]]; then
        export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    else
        export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    fi

    export M2_HOME=/opt/maven
    export PATH="$M2_HOME/bin:$PATH"

    echo "[INFO] Clean up"
    rm -rf "apache-maven-${MAVEN_VERSION}-bin.tar.gz"

    if ! mvn --version &>/dev/null; then
        echo "[FAIL ❌] Maven installation failed!"
        exit 1
    fi

    echo "[CHECKED ✅] Maven installed! Try 'mvn -v'"
else
    echo "[CHECKED ✅] Maven already installed! Try 'mvn -v'"
fi