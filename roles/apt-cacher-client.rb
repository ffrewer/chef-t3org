name "apt-cacher-client"
description "Role for activating apt-cacher. This speeds up provisioning on Debian/Ubuntu Machines. IMPORTANT: Use in dkd LAN only, otherwise set host to 'nil'"

run_list(
  "recipe[apt::cacher-client]"
)

override_attributes(
   "apt" => {
     "cacher" => {
       "host" => "vagrant.dkd.lan",
       "port" => 3142
     }
   }
)
