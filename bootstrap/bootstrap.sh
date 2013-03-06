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
  aptitude -y install dkms

  # unecessary daemons
  aptitude -y purge whoopsie acpid nfs-common rpcbind

  # remove crap from vagrant cloud images
  aptitude -y purge juju puppet graphviz fontconfig libpango1.0-0 libgvc5 \
              x11-common libxt6 libxmu6 libxaw7 libsm6 libice6 bzr debconf-utils fontconfig \
              fontconfig-config fonts-liberation libcairo2 libcap2 libcdt4 libcgraph5 \
              libdatrie1 libfontconfig1 libgd2-noxpm libgraph4 libgssglue1 libgvc5 libgvpr1 \
              libjpeg8 libjpeg-turbo8 libnfsidmap2 libpango1.0-0 libpathplan4 libpixman-1-0 \
              libthai0 libthai-data libtirpc1 libxcb-render0 libxcb-shm0 libxft2 libxpm4 \
              libxrender1 python-bzrlib ttf-dejavu-core ttf-liberation puppet-common \
              libaugeas0 libfontenc1 libllvm3.0 libxcomposite1 libxdamage1 libxfixes3 \
              libxfont1 libxkbfile1 libxrandr2 libzookeeper-mt2 puppet-common \
              python-support python-twisted python-twisted-conch xfonts-base xfonts-utils \
              xserver-xorg-core virtualbox-guest-x11 libgl1-mesa-dri \
              x11-xkb-utils xfonts-encodings xserver-common

  # don't start getty
  for a in $(set +f; cd /etc/init && ls -d tty*.conf); do
    echo "manual" >> "/etc/init/$a"
  done

  # ruby
  aptitude -y install ruby rdoc ri irb rubygems ruby-dev 
  aptitude -y install build-essential libxml2-dev libxslt-dev # minimum to build chef, chefspec, foodcritic, minitest-chef-handler, nokogiri
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
  ### END finished.sh

  poweroff
}

main "$@"
