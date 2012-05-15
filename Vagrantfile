# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.ssh.max_tries = 100

  config.vm.box = "debian-6-amd64"
  config.vm.box_url = "http://dl.dropbox.com/u/344103/debian-6-amd64.box"
  config.vm.boot_mode = :gui
  #config.vm.network :hostonly, "192.168.156.120"
  config.vm.host_name = 'typo3.dev'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path  = ["cookbooks"]
    chef.roles_path      = ["roles"]
    chef.data_bags_path  = ["data_bags"]

    # Turn on verbose Chef logging if necessary
    #chef.log_level      = :debug

    # List the recipies you are going to work on/need.
    chef.add_role     "debian"
    chef.add_role     "vagrant"
  end

  config.vm.customize [
    "modifyvm", :id,
    "--name", "typo3.dev",
    "--memory", "512"
  ]
end
