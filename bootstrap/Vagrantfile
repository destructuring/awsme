Vagrant::Config.run do |config|
  config.vm.box = "precise-cloud-init"
  config.vm.base_mac = "auto"
  Vagrant::Config.run do |config|
      config.vm.provision :shell, :path => "vagrant.sh", :args => "virtualbox"
  end
end

# vi: set ft=ruby :
