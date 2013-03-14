#!/bin/bash -exfu

exec > >(tee -a /var/log/awsme.log | logger -t awsme -s) 2>&1

function main {
  aptitude clean

  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*
}

main "$@"
