#!/bin/bash -e

source_dir=$(dirname "$0")

usage()
{
    echo 'Generate jenkins environment'
    echo 'usage: ./generate_env.sh [-h] [options]'
    echo
    echo 'optional arguments:'
    echo '  --tftp-dir TFTP_DIR set     tftp dir when using host tftp server'
    echo '  --nfs-dir NFS_DIR set       nfs dir when using host nfs server'
    echo '  -h, --help                  show this help message and exit'
}

options=$(getopt -o hi:d: --long tftp-dir:,nfs-dir:,help -- "$@")

eval set -- "$options"
while true; do
    case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    --tftp-dir)
        shift
        tftp_dir="$1"
        ;;
    --nfs-dir)
        shift
        nfs_dir="$1"
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

cd "${source_dir}"

# Set docker group id on the .env file
docker_gid=$(cut -d: -f3 <(getent group docker))

# Create /var/jenkins_home on the host machine
if [ ! -d /var/jenkins_home ] ; then
    sudo mkdir -p -v /var/jenkins_home
    sudo chown 1000:1000 /var/jenkins_home
fi

# Create TFTP shared folder if tftp_dir is not set
if [ -z "${tftp_dir}" ] ; then
    tftp_dir="/var/jenkins_home/tftp"
    if [ ! -d /var/jenkins_home/tftp ] ; then
        sudo mkdir -p -v /var/jenkins_home/tftp
        sudo chown 1000:1000 /var/jenkins_home/tftp
    fi
fi

# Create NFS shared folder if nfs_dir is not set
if [ -z "${nfs_dir}" ] ; then
    nfs_dir="/var/jenkins_home/nfs"
    if [ ! -d /var/jenkins_home/nfs ] ; then
        sudo mkdir -p -v /var/jenkins_home/nfs
        sudo chown 1000:1000 /var/jenkins_home/nfs
    fi
fi

# For using yocto cache
if [ ! -d /var/jenkins_home/yocto ] ; then
    sudo mkdir -p -v /var/jenkins_home/yocto/{dl,sstate}
    sudo chown -R 1000:1000 /var/jenkins_home/yocto
fi

timezone=$(timedatectl status | awk '/Time zone/{ print $3 }')

cat >.env << EOF
_CI_DOCKER_GID=${docker_gid}
NFS_DIR=${nfs_dir}
TFTP_DIR=${tftp_dir}
TIMEZONE=${timezone}
EOF
