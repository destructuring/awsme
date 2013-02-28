#!/bin/bash -exfu

function main {
  local container

  if [[ "$#" = 0 ]]; then
    container="ec2" # dumb but can't figure how to pass an argument through user-data/cloud-init
  else
    container="$1"; shift
  fi

  # This logs the output of the user-data. http://alestic.com/2010/12/ec2-user-data-output
  exec > >(tee /var/log/awsme.log | logger -t awsme -s) 2>&1

  # Stop instance before first hour, probably a runaway instance by then
  echo poweroff | at now + 50 minutes

  # Update and install various packages
  export DEBIAN_FRONTEND=noninteractive

  aptitude update
  aptitude -y dist-upgrade
  aptitude -y upgrade
  aptitude -y install dkms
  aptitude hold linux-headers linux-{,{headers,image}-}{generic,server,virtual}

  # basic packages
  aptitude -y install wget curl nc git rsync make

  # ruby
  aptitude -y install ruby rdoc ri irb rubygems ruby-dev 
  aptitude -y install \
    build-essential openssl libreadline6 libreadline6-dev curl zlib1g \
    zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev \
    libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison \
    pkg-config # as recommended by rvm
  gem install bundler --no-ri --no-rdoc -v '~> 1.2.5'

  # finishing up
  aptitude clean
  atrm $(at -l | awk '{print $1}')

  # remove cached network configurations
  rm -fv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  # don't see a battery
  rm -fv /etc/dbus-1/system.d/org.freedesktop.UPower.conf

  if [[ "$container" = "ec2" ]]; then
    poweroff # signal the controller to bundle stopped instance
  fi
}

main "$@"
