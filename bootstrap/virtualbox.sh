#!/bin/bash -exfu

exec > >(tee -a /var/log/awsme.log | logger -t awsme -s) 2>&1

function main {

  export DEBIAN_FRONTEND="noninteractive"

  # remove crap from vagrant cloud images to match ec2
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

  aptitude purge -y virtualbox-guest-{dkms,utils,x11}

  cp /vagrant/boxes/VBoxGuestAdditions.iso ~/
  mount -o loop ~/VBoxGuestAdditions.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm -f ~/VBoxGuestAdditions.iso
}

main "$@"

