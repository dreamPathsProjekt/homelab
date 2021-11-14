#!/usr/bin/env bash

set -o errexit
set -o pipefail

_kind_version="${KIND_VERSION:-v0.11.1}"

set -o nounset

command_exists() {
    command -v "$1"
}

docker_install_ubuntu() {
    docker_exists=$(command_exists docker)
    if [ -e "$docker_exists" ]; then
        echo "Skipping Docker install"
        exit 0
    fi
    echo -e "Installing Docker CE"
    apt-get -y remove docker docker-engine docker.io containerd runc
    apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

    echo "Performing Post-Install Steps"
    systemctl enable docker.service
    systemctl enable containerd.service
    groupadd docker
    usermod -aG docker "$USERNAME"
}

kind_install(){
    kind_exists=$(command_exists kind)
    if [ -e "$kind_exists" ]; then
        echo "Skipping Kind install"
        exit 0
    fi
    echo -e "Installing Kind"
    wget "https://github.com/kubernetes-sigs/kind/releases/download/$_kind_version/kind-linux-amd64" && \
    chmod +x kind-linux-amd64 && \
    mv -v kind-linux-amd64 kind && \
    install -t /usr/local/bin/ kind && \
    rm -vf kind && \
    kind --version
}

case "$1" in
    install)
        case "$2" in
            docker)
              docker_install_ubuntu
              exit 0
              ;;
            kind)
              kind_install
              exit 0
              ;;
        esac
    exit 0
    ;;
esac
