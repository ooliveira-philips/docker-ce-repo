#!/usr/bin/env bash
set -e

yum -y install curl wget openssl ca-certificates yum-utils sudo

cat << EOF > /etc/yum.repos.d/philips-emr-el7.repo
[philips-emr-el7]
name=philips-emr-el7
baseurl=https://repo.tasy.com.br/pub/repo/release/el7/
enable=1
gpgcheck=0
metadata_expire=10m
EOF

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

osid=$(grep -Po "(?<=^ID=\").*(?=\")" /etc/os-release)
if [ "$osid" == "ol" ]; then # oracle linux
    yum-config-manager --enable ol7_addons
    sed -i 's|baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable|baseurl=https://download.docker.com/linux/centos/7/$basearch/stable|g' /etc/yum.repos.d/docker-ce.repo
    cat << EOF > /etc/yum.repos.d/CentOS-Extras.repo
[centos_extras]
name=CentOS-7 - Extras
mirrorlist=http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=extras&infra=stock
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF
    rpm --import http://mirror.turbozoneinternet.net.br/centos/RPM-GPG-KEY-CentOS-7
    elif [ "$osid" == "rhel" ]; then # redhat
    yum-config-manager --enable rhel-7-server-extras-rpms
fi
