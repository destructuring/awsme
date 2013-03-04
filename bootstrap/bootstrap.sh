#!/bin/bash -exfu

function main {
  # This logs the output of the user-data. http://alestic.com/2010/12/ec2-user-data-output
  exec > >(tee /var/log/awsme.log | logger -t awsme -s) 2>&1

  # Stop instance before first hour, probably a runaway instance by then
  echo poweroff | at now + 50 minutes

  # Update and install various packages
  export DEBIAN_FRONTEND=noninteractive

  aptitude update
  aptitude -y dist-upgrade
  aptitude -y upgrade
  aptitude hold linux-headers linux-{,{headers,image}-}{generic,server,virtual}

  update-ca-certificates --fresh

  # basic packages
  aptitude -y install wget curl netcat git rsync make

  # unecessary daemons
  aptitude -y purge whoopsie acpid nfs-common rpcbind

  # don't start getty
  for a in $(set +f; ls -d /etc/init/tty*.conf); do
    echo "manual" >> "$a"
  done

  # ruby
  aptitude -y install ruby rdoc ri irb rubygems ruby-dev 
  aptitude -y install build-essential libxml2-dev # minimum to build chef, chefspec, foodcritic, minitest-chef-handler
  gem install bundler --no-ri --no-rdoc -v '~> 1.2.5'

  # finishing up
  atrm $(at -l | awk '{print $1}')

  ### START finished.sh
  aptitude clean

  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  # don't see a battery
  rm -fv /etc/dbus-1/system.d/org.freedesktop.UPower.conf
  ### END finished.sh

  poweroff
}

main "$@"
