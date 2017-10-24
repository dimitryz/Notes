# vim: syntax=ruby

Vagrant.configure("2") do |config|
  config.vm.box = "xenji/ubuntu-17.04-server"
  config.vm.host_name = "app"
  config.vm.network :private_network, ip: "192.168.1.99"
  # config.vm.provision "shell", path: "NotesServer/Scripts/provision_swift.sh"
end
