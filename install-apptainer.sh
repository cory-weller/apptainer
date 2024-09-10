#!/usr/bin/env bash

sudo rm -rf /usr/local/go
sudo rm -rf /usr/local/bin/singularity

# Edit as needed to RHEL
DISTRO='DEBIAN'

if [[ ${DISTRO} == 'RHEL' ]]; then
    # Install basic tools for compiling
    sudo dnf groupinstall -y 'Development Tools'
    # Ensure EPEL repository is available
    sudo dnf install -y epel-release
    # Install RPM packages for dependencies
    sudo dnf install -y \
        libseccomp-devel \
        squashfs-tools \
        fakeroot \
        cryptsetup \
        wget git
elif [[ ${DISTRO} == 'DEBIAN' ]]; then
    # Ensure repositories are up-to-date
    sudo apt-get update
    # Install debian packages for dependencies
    sudo apt-get install -y \
        build-essential \
        libseccomp-dev \
        pkg-config \
        uidmap \
        squashfs-tools \
        fakeroot \
        cryptsetup \
        tzdata \
        dh-apparmor \
        curl wget git
fi


export GOVERSION=1.21.0 OS=linux ARCH=amd64  # change this as you need

wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
  https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz

sudo tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/apptainer/apptainer.git
cd apptainer

git checkout v1.3.4

./mconfig
cd $(/bin/pwd)/builddir
make
sudo make install
