#!/bin/bash -exfu

exec > >(tee -a /var/log/awsme.log | logger -t awsme -s) 2>&1

function main {
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
  aptitude -y install dkms

  # unecessary daemons
  aptitude -y purge whoopsie acpid nfs-common rpcbind

  # ruby
  aptitude -y install ruby rdoc ri irb rubygems ruby-dev 

  gem install bundler --no-ri --no-rdoc -v '~> 1.2.5'

  # don't start getty
  for a in $(set +f; cd /etc/init && ls -d tty*.conf); do
    echo "manual" >> "/etc/init/$a"
  done

  # finishing up
  atrm $(at -l | awk '{print $1}')

  ### START finished.sh
  aptitude clean

  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*
  ### END finished.sh

  # power off for bundling
  poweroff
}

main "$@"
