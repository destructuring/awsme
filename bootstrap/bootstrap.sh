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

  # basic packages
  aptitude -y install wget curl netcat git rsync make

  # ruby
  aptitude -y install ruby rdoc ri irb rubygems ruby-dev 
  aptitude -y install build-essential curl zlib1g-dev libreadline-gplv2-dev \
                      libxml2-dev libsqlite3-dev file git bison adduser # ruby-rvm package dependencies
  gem install bundler --no-ri --no-rdoc -v '~> 1.2.5'

  # finishing up
  aptitude clean
  atrm $(at -l | awk '{print $1}')

  # TODO duplication for ec2, see finished.sh
  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  # don't see a battery
  rm -fv /etc/dbus-1/system.d/org.freedesktop.UPower.conf

  poweroff
}

main "$@"
