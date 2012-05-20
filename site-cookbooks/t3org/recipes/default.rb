#
# Cookbook Name:: typo3
# Recipe:: default
#
# Copyright 2012, Christian Trabold, Sebastiaan van Parijs
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#######################################
# Install missing package
#######################################
include_recipe "apache2::mod_php5"

template "/etc/php5/apache2/php.ini" do
  source "php.erb"
  owner "root"
  group "root"
  notifies :restart, 'service[apache2]'
end

#######################################
# Install restore script
#######################################
template "/root/restore_backup.sh" do
  source "restore_backup.erb"
  owner "root"
  group "root"
  mode "0755"
end

#######################################
# Download archive and extract
#######################################

if ! File.exists? '/root/t3org.tar.gz'

  remote_file "/root/t3org.tar.gz" do
    source "http://www.testing5.dev.t3o-relaunch-week.de/artifacts/trunk/2658/t3o-fabien.udriot.tar.gz"
    mode "0644"
  end

  script "extract_archive" do
    interpreter "bash"
    user "root"
    cwd "/root"
    code <<-EOH
    if [ ! -f /root/t3o-fabien.udriot ];
    then
      tar -zxf /root/t3org.tar.gz -C /root
    fi
    EOH
  end

end

#######################################
# Run script
#######################################

script "install_t3org" do
  interpreter "bash"
  user "root"
  cwd "/root"
  Chef::Log.info "Running restore backup script which will take some time..."
  code <<-EOH
  #if [ ! -f /var/www/vhosts/t3org.dev/www/ ];
  #then
      #/root/restore_backup.sh -u root -p root -h localhost -d t3orgdev -r /var/www/vhosts/t3org.dev/ -s /root/t3o-fabien.udriot -f
  #fi

  if [ -f /var/www/vhosts/t3org.dev/htdocs ];
  then
      mv /var/www/vhosts/t3org.dev/htdocs/.htaccess /var/www/vhosts/t3org.dev/www
      mv /var/www/vhosts/t3org.dev/htdocs/* /var/www/vhosts/t3org.dev/www
      rmdir /var/www/vhosts/t3org.dev/htdocs

      # Set permissions to maximal since in development
      chown -R www-data:www-data /var/www/vhosts/t3org.dev/www
      chmod -R 777 /var/www/vhosts/t3org.dev/www

      # Create ENABLE_INSTALL_TOOL
      touch /var/www/vhosts/t3org.dev/www/typo3conf/ENABLE_INSTALL_TOOL

      # Todo edit
      #'5f4dcc3b5aa765d61d8327deb882cf99';  by 5f4dcc3b5aa765d61d8327deb882cf99
  fi

  service apache2 restart
  EOH
end