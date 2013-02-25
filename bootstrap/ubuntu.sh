#!/bin/bash -ex

function main {
  # This logs the output of the user-data. http://alestic.com/2010/12/ec2-user-data-output
  exec > >(tee /var/log/awsme.log | logger -t awsme -s 2>/dev/console) 2>&1

  # Stop instance before first hour, probbaly a runaway instance by then
  echo poweroff | at now + 50 minutes

  # Update and install various packages
  export DEBIAN_FRONTEND=noninteractive

  aptitude update
  aptitude -y dist-upgrade
  aptitude -y upgrade
  aptitude hold linux-headers linux-{,{headers,image}-}{generic,server,virtual}

  # basic packages
  aptitude -y install wget curl nc git rsync make

  # ruby
  aptitude -y install build-essential ruby rdoc ri irb rubygems ruby-dev libxslt-dev libxml2-dev
  gem install bundler -v '~> 1.2.4'

  # finishing up
  aptitude clean
  atrm $(at -l | awk '{print $1}')
  poweroff
}

main "$@"
