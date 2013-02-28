Vagrant::Config.run do |config|
  config.vm.box = "awsme"
  config.vm.base_mac = "auto"
  Vagrant::Config.run do |config|
      config.vm.provision :shell, :path => "vagrant.sh", :args => "virtualbox"
  end
end

# vi: set ft=ruby :
