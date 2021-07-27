#!/bin/bash -e

source_dir=$(dirname "$0")

if [ $# -gt 0 ] ; then
    echo "Error this script takes no arguments"
    exit 1
fi

cd "${source_dir}"

# Set docker group id on the .env file
docker_gid=$(cut -d: -f3 <(getent group docker))

# Create /var/jenkins_home on the host machine
if [ ! -d /var/jenkins_home ] ; then
    sudo mkdir -p -v /var/jenkins_home
    sudo chown 1000:1000 /var/jenkins_home
fi

# Create TFTP shared folder
if [ ! -d /var/jenkins_home/tftp ] ; then
    sudo mkdir -p -v /var/jenkins_home/tftp
    sudo chown 1000:1000 /var/jenkins_home/tftp
fi

# Create NFS shared folder
if [ ! -d /var/jenkins_home/nfs ] ; then
    sudo mkdir -p -v /var/jenkins_home/nfs
    sudo chown 1000:1000 /var/jenkins_home/nfs
fi

# For using yocto cache
if [ ! -d /var/jenkins_home/yocto ] ; then
    sudo mkdir -p -v /var/jenkins_home/yocto/{dl,sstate}
    sudo chown -R 1000:1000 /var/jenkins_home/yocto
fi

cat >.env << EOF
_CI_DOCKER_GID=${docker_gid}
EOF
