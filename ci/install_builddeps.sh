#!/bin/bash

. /etc/os-release

# RHEL
if [ -n "$(echo "$ID_LIKE"  | grep "rhel")" ]; then
  dnf check-update  
  dnf -y install yum-utils 'dnf-command(config-manager)'
  dnf config-manager --set-enabled crb
  dnf builddep ./packaging/rpm/cvmfs-universal.spec
fi

# SUSE

if [ -n "$(echo "$ID_LIKE"  | grep "suse")" ]; then
  zypper --non-interactive update
  zypper --non-interactive install git curl tar gzip rpm-build
  zypper -n install  $(rpmspec --parse ./packaging/rpm/cvmfs-universal.spec | grep BuildRequires | cut -d' ' -f2 | xargs)
fi


# Debian-based
if [ -n "$(echo "$ID_LIKE" "$ID"  | grep "debian")" ]; then
  apt-get update
  apt-get install -y devscripts equivs
  mk-build-deps ./packaging/debian/cvmfs/control
  apt-get install -y ./cvmfs-build-deps_*_all.deb
  rm cvmfs-build-deps_*
fi


