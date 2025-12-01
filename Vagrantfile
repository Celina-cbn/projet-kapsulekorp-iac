Vagrant.configure("2") do |config|
  
  config.vm.box = "bento/ubuntu-22.04"

  config.vm.define "web1-staging" do |web|
    web.vm.hostname = "web1-staging"
    web.vm.network "private_network", ip: "10.184.28.10"
  end

  config.vm.define "web2-staging" do |web|
    web.vm.hostname = "web2-staging"
    web.vm.network "private_network", ip: "10.184.28.11"
  end

  config.vm.define "db-staging" do |db|
    db.vm.hostname = "db-staging"
    db.vm.network "private_network", ip: "10.184.28.12"
  end

  config.vm.define "web1-production" do |web|
    web.vm.hostname = "web1-production"
    web.vm.network "private_network", ip: "10.184.28.20"
  end

  config.vm.define "web2-production" do |web|
    web.vm.hostname = "web2-production"
    web.vm.network "private_network", ip: "10.184.28.21"
  end

  config.vm.define "web3-production" do |web|
    web.vm.hostname = "web3-production"
    web.vm.network "private_network", ip: "10.184.28.22"
  end

  config.vm.define "db-production" do |db|
    db.vm.hostname = "db-production"
    db.vm.network "private_network", ip: "10.184.28.23"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.inventory_path = "inventory.ini"
    ansible.host_key_checking = false
  end

end
