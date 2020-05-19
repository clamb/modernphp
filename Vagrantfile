# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'optparse'

def replace(src_filename, dest_filename, str)
  File.open(dest_filename, "w") do |f|
    File.open(src_filename).each do |line|
      new_line = line.gsub("modernphp", str)
      f.write(new_line)
    end
  end
end

def create_conf_file(name)
  conf_filename = "#{name}.local.conf"

  conf = <<-CONF
  <VirtualHost *:80>
    ServerAdmin admin@example.org
    DocumentRoot /var/www/#{name}
    ServerName #{name}.local
    ErrorLog /var/log/apache2/#{name}_error.log
    CustomLog /var/log/apache2/#{name}_access.log common
    <FilesMatch \.php$>
      SetHandler "proxy:unix:/var/run/php/php7.4-fpm.sock|fcgi://localhost"
    </FilesMatch>
  </VirtualHost>
  
  <VirtualHost *:443>
    ServerAdmin admin@example.org
    DocumentRoot /var/www/#{name}
    ServerName #{name}.local
    SSLEngine on
    SSLCertificateFile /etc/ssl/crt/#{name}.local.crt
    SSLCertificateKeyFile /etc/ssl/crt/#{name}.local.key
    ErrorLog /var/log/apache2/#{name}_error.log
    CustomLog /var/log/apache2/#{name}_access.log common
    <FilesMatch \.php$>
      SetHandler "proxy:unix:/var/run/php/php7.4-fpm.sock|fcgi://localhost"
    </FilesMatch>
  </VirtualHost>
  
  <Directory /var/www/#{name}>
    AllowOverride all
  </Directory>
  CONF
  
  File.open(conf_filename, "w") do |f|
    f.write(conf)
  end
  
end

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: vagrant --name=NAME up"

  opts.on("-nMANDATORY", "--name=MANDATORY", "Name of the machine") do |name|
    options[:name] = name
  end
end

option_parser.parse!

if ARGV[0] == "up"
  if options[:name].nil?
    puts option_parser.help
    exit 1
  end
  create_conf_file(options[:name])
  plist_file = "#{options[:name]}.sequel_pro.plist"
  replace('sequel_pro_modernphp.plist', plist_file, options[:name])
  replace('setup_template.sh', 'setup.sh', options[:name])
  File.open(".config", "w") do |f|
    f.write("name=#{options[:name]}")
  end
end

name = ''


if !File.exists?(".config")
  puts "Missing configuration file (.config)"
  exit 1
end

File.open(".config", "r").each do |line|
  if /^name=(\w+)/.match(line)
    name = $1
  end
end

if name == ''
  puts "Missing name=<name> inside .config"
  exit 1
end


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.box_version = "202005.12.0"
  config.vm.network :private_network, :auto_network => true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vm.hostname = "#{name}.local"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "forwarded_port", guest: 1080, host: 1080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network "private_network", ip: "192.168.100.100"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./www", "/var/www/#{name}", :owner => 'www-data', :group => 'www-data'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.name = "#{name}-ubuntu-php7"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "setup.sh"
end
