#!/bin/bash -exfu

function main {
  cp /vagrant/VBoxGuestAdditions.iso ~/

  export DEBIAN_FRONTEND="noninteractive"

  aptitude purge -y virtualbox-guest-{dkms,utils,x11}
  aptitude purge -y cloud-init
  aptitude install -q -y dkms
  aptitude clean

  mount -o loop ~/VBoxGuestAdditions.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt

  echo "dhclient eth1" > /etc/rc.local
  poweroff
}

main "$@"
