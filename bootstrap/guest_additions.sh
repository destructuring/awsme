#!/bin/bash -exfu

function main {
  exec > >(tee -a /var/log/awsme.log | logger -t awsme -s) 2>&1

  cp /vagrant/boxes/VBoxGuestAdditions.iso ~/

  export DEBIAN_FRONTEND="noninteractive"

  aptitude purge -y virtualbox-guest-{dkms,utils,x11}
  aptitude purge -y cloud-init
  aptitude install -q -y dkms
  aptitude clean

  mount -o loop ~/VBoxGuestAdditions.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm -f ~/VBoxGuestAdditions.iso

  # remove cached network configurations
  rm -fv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  # don't see a battery
  rm -fv /etc/dbus-1/system.d/org.freedesktop.UPower.conf

  poweroff
}

main "$@"
