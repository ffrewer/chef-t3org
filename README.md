# Overview

This is a repository used for the TYPO3 chef workshop.

# Requirements

## Chef environment

To get started you need a environment as described here:

  http://wiki.opscode.com/display/chef/Workstation+Setup

You'll especially need

- git
- gcc compilers and headers (eg. XCode / build-essential)
- Ruby 1.9.3 Dev Environment
  https://rvm.io/rvm/install/
- Chef 0.10.8

## Virtualbox + Vagrant

- Virtualbox 4.1 (4.0 should be fine too) + Vagrant 1.0.3
  http://vagrantup.com/docs/getting-started/index.html
- A Debian 6.04 Box for Vagrant
  The box gets downloaded by Vagrant automatically.

  You might want to download it from
    http://dl.dropbox.com/u/344103/debian-6-amd64.box

  You can add it as a vagrant box like this:
	vagrant box add debian-6-amd64 http://dl.dropbox.com/u/344103/debian-6-amd64.box

## Gems

Bundler

  gem install bundler --no-ri --no-rdoc

Then run this command to install the basic gems needed:

	bundle install

Please also install these gems which can not be installed by bundler at the moment because of invalid dependencies:

#- A bundler for your Chef-based infrastructure repositories (http://rubydoc.info/gems/librarian/frames)
#
#	gem install librarian

#- A lint tool for your Opscode Chef cookbooks (http://acrmp.github.com/foodcritic/)
#
#	gem install foodcritic

## Librarian
#
#Once installed, run librarian-chef to copy the chef cookbooks to the local host:
#
#	librarian-chef install


## Create a cookbook

Because we have a modified `knife.rb` in the `.chef` directory,
this command creates new cookbooks inside `./site-cookbooks`:

	knife create cookbook my_awesome_cookbook

Now you can remove unneeded folders like `definitions`.

To add the new cookbook I recommend to create a new role and
add the recipe to the run_list:

	$ cat workshop.rb
	name "workshop"
	description "Role for the workshop."

	run_list(
	  "recipe[workshop]"
	)


	$ cat Vagrantfile
	chef.add_role       "workshop"

or through a role:


# Notes

## TODO

* Check, if we can run tests only in development environment
http://wiki.opscode.com/display/chef/Environments
* Can tests run only if something changed?

## Problems

If your box does not finish booting up, it is most likely caused by networking issues.

- Run vagrant using the following line:

	config.vm.boot_mode = :gui

- Next, login using "vagrant" / "vagrant"

- Now run "sudo -s" and try to fix the problem manually:

	sudo /etc/init.d/networking restart

If that helps, you might try adding the following line to /etc/rc.local (right before "exit 0"):

	sh /etc/init.d/networking restart

(Source: https://github.com/mitchellh/vagrant/issues/391)


## Usage of cookbooks and librarian-chef

- cookbooks store the pristine upstream community cookbooks

- cookbooks must NEVER be edited, use site-cookbooks for custom and/or adapted cookbooks

- use 'librarian-chef outdated' to find new upstream cookbooks

- adapt Cheffile if you want to test/use different version, use 'librarian-chef install' to install them
  in the configured versions

- mind the usage of 'librarian-chef update'! as if will update the cookbooks and deploy them into our infrastructure
