#!/bin/bash -exfu

function main {
  export DEBIAN_FRONTEND="noninteractive"

  cp /vagrant/VBoxGuestAdditions.iso ~/
  aptitude purge -y virtualbox-guest-{dkms,utils,x11}
  aptitude install -q -y dkms
  aptitude clean

  mount -o loop ~/VBoxGuestAdditions.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt

  poweroff
}

main "$@"
