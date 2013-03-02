#!/bin/bash -exfu

function main {
  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  # don't see a battery
  rm -fv /etc/dbus-1/system.d/org.freedesktop.UPower.conf
}

main "$@"
