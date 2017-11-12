# vim: syntax=ruby

Vagrant.configure("2") do |config|
  config.vm.box = "xenji/ubuntu-17.04-server"
  config.vm.network "forwarded_port", guest: 80, host: 8000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "shell", path: "Scripts/provision.sh"
end
