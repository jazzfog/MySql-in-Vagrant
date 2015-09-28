Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.name = "MySQL with persistent data"
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.network "private_network", ip: "192.168.100.120"
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  # Run only once, when VM is being provisioned
  config.vm.provision "shell", path: "provision/provision.sh"

  # Run every time when VM starts
  config.vm.provision "shell", path: "provision/up.sh", run: "always"

end