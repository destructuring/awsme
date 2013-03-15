#!/bin/bash -exfu

function main {
  local ver_vbox="$1"; shift

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

  # rebuild guest additions
  aptitude purge -y virtualbox-guest-{dkms,utils,x11}

  wget http://download.virtualbox.org/virtualbox/${ver_vbox}/VBoxGuestAdditions_${ver_vbox}.iso
  mount -o loop ~/VBoxGuestAdditions_${ver_vbox}.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm -f ~/VBoxGuestAdditions_${ver_vbox}.iso

  ### START finished.sh
  aptitude clean

  # remove cached network configurations
  rm -rfv /etc/udev/rules.d/70-persistent-net.rules
  mkdir -pv /etc/udev/rules.d/70-persistent-net.rules
  rm -fv /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rfv /dev/.udev/ /var/lib/dhcp3/*

  poweroff
  ### END finished.sh
}

exec > >(tee -a /var/log/awsme.log | logger -t virtualbox -s) 2>&1

main "$@"
