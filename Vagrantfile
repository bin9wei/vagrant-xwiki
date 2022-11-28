Vagrant.configure("2") do |config|
  # https://app.vagrantup.com/centos/boxes/7
  config.vm.box = "centos/7"
  config.vm.network "forwarded_port", guest: 8080, host: 18080
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
  
  config.vm.provision 'shell', path: 'provision.sh'
end