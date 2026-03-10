#! /bin/bash

MAVEN_VERSION=3.9.13

if ! mvn --version &> /dev/null
then
    wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
    tar -xvzf apache-maven-$MAVEN_VERSION-bin.tar.gz
    sudo cp apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin
    sudo mv apache-maven-$MAVEN_VERSION /opt/maven

    # Set JAVA_HOME environment variable for Maven
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    export M2_HOME=/opt/maven
    export PATH="$M2_HOME/bin:$PATH"

    echo "[INFO] >>>> Clean Up"
    rm -drf apache-maven-$MAVEN_VERSION-bin.tar.gz apache-maven-$MAVEN_VERSION

    if ! mvn --version &> /dev/null; then
        echo "[FAIL ❌] Maven installation failed!"
        exit 1
    fi


    echo "[CHECKED ✅] Maven installed! Try 'mvn -v'"
else
    echo "[CHECKED ✅] Maven has been already installed! Try 'mvn -v'"
fi