node[:deploy].each do |application, deploy|
  execute 'sudo yum -y remove php*'
  execute 'sudo yum -y remove httpd*'

  execute 'sudo yum -y install php54'
  execute 'sudo yum -y install httpd24'

  yum_package 'mod24_ssl' do
    action :upgrade
  end

  yum_package 'php54-gd' do
    action :upgrade
  end

  yum_package 'php54-pgsql' do
    action :upgrade
  end

  yum_package 'php54-mcrypt' do
    action :upgrade
  end

  yum_package 'php54-pecl-memcache' do
    action :upgrade
  end

  yum_package 'php54-pecl-memcached' do
    action :upgrade
  end

  # Create folder
  directory "/var/www/codebases" do
    mode 0755
    action :create
  end

  directory "/var/www/skydata" do
    mode 0777
    action :create
  end

  directory "/var/www/html" do
    mode 0755
    action :create
  end

  directory "/var/www/cert" do
    mode 0755
    action :create
  end

  directory "/var/www/logs" do
    mode 0755
    action :create
  end

  directory "/root/.ssh" do
    mode 0755
    action :create
  end

  # Put ssh key
  template "/root/.ssh/github_private_key" do
    Chef::Log.debug("Generating private key")
    source 'github_private_key.erb'
    mode '0400'
  end

  # ssh_known_hosts "github.com" do
  #   hashed true
  # end

  # ssh_config "github.com" do
  #   options 'User' => 'git', 'IdentityFile' => '/root/.ssh/github_private_key'
  #   user 'webapp'
  # end

  file "/root/git_wrapper.sh" do
    mode "0755"
    content "#!/bin/sh\nexec /usr/bin/ssh -i /root/.ssh/github_private_key \"$@\""
  end

  # Setup everything at /var/www/codebases
  fullLists = {
    'skyphp' => { 'url' => 'git@github.com:SkyPHP/skyphp.git', 'branch' => '3.0-beta' },
    'cms' => { 'url' => 'git@github.com:SkyPHP/cms.git', 'branch' => '3.0' },
    'crave-deploy' => { 'url' => 'git@github.com:SkyPHP/crave-deploy.git', 'branch' => 'master' },
    'crave-event' => { 'url' => 'git@github.com:SkyPHP/crave-event.git', 'branch' => 'master' },
    'crave-inc' => { 'url' => 'git@github.com:SkyPHP/crave-inc.git', 'branch' => '3.0' },
    'crave-reseller' => { 'url' => 'git@github.com:SkyPHP/crave-reseller.git', 'branch' => '3.5' },
    'crave-sites' => { 'url' => 'git@github.com:SkyPHP/crave-sites.git', 'branch' => 'master' },
    'crave-templates' => { 'url' => 'git@github.com:SkyPHP/crave-templates.git', 'branch' => 'master' },
    'cravetix' => { 'url' => 'git@github.com:SkyPHP/cravetix.git', 'branch' => '3.0' },
    'downtowncountdown.net' => { 'url' => 'git@github.com:SkyPHP/downtowncountdown.net.git', 'branch' => 'master' },
    'halloweenparties.com' => { 'url' => 'git@github.com:SkyPHP/halloweenparties.com.git', 'branch' => 'master' },
    'jb-inc' => { 'url' => 'git@github.com:SkyPHP/jb-inc.git', 'branch' => '3.0' },
    'jb-production' => { 'url' => 'git@github.com:SkyPHP/jb-production.git', 'branch' => 'aws' },
    'joonbug-v3' => { 'url' => 'git@github.com:SkyPHP/joonbug-v3.git', 'branch' => 'master' },
    'lindys' => { 'url' => 'git@github.com:SkyPHP/lindys.git', 'branch' => 'master' },
    'newyears.com' => { 'url' => 'git@github.com:SkyPHP/newyears.com.git', 'branch' => 'master' },
    'newyearseve.com' => { 'url' => 'git@github.com:SkyPHP/newyearseve.com.git', 'branch' => 'master' },
    'newyearsevecentral.com' => { 'url' => 'git@github.com:SkyPHP/newyearsevecentral.com.git', 'branch' => 'master' },
    'nyephilly' => { 'url' => 'git@github.com:SkyPHP/nyephilly.git', 'branch' => 'master' },
    'timessquarenewyears3' => { 'url' => 'git@github.com:SkyPHP/timessquarenewyears3.git', 'branch' => 'master' },
    'barcrawls' => { 'url' => 'git@github.com:SkyPHP/barcrawls.git', 'branch' => '3.0' }
  }

  base = '/var/www/codebases/'
  
  fullLists.each do |name, detail|
    Chef::Log.debug("Processing repository #{name}")
    if Dir.exists?(base + name) == false
      git "#{base}#{name}" do
        repository detail['url']
        checkout_branch detail['branch']
        enable_submodules true
        revision detail['branch']
        action :sync
        ssh_wrapper "/root/git_wrapper.sh"
      end
    end
  end

  # Create index and link .htaccess
  template "/var/www/html/index.php" do
    Chef::Log.debug("Generating index.php")
    source 'index.php.erb'
    mode '0754'
  end

  template "/var/www/html/.htaccess" do
    Chef::Log.debug("Generating htaccess")
    source 'htaccess.erb'
    mode '0777'
  end

  template "/var/www/cert/cravetickets.com.crt" do
    source 'cravetickets.com.crt.erb'
    mode '0644'
  end

  template "/var/www/cert/cravetickets.com.csr" do
    source 'cravetickets.com.csr.erb'
    mode '0644'
  end

  template "/var/www/cert/cravetickets.com.key" do
    source 'cravetickets.com.key.erb'
    mode '0644'
  end

  template "/var/www/cert/gd.crt" do
    source 'gd.crt.erb'
    mode '0644'
  end

  template "/etc/httpd/conf.d/httpd-vhosts.conf" do
    source 'httpd-vhosts.conf.erb'
    mode '0644'
  end

  # Process apache config
  # remove all existing links
  execute 'mv away all existing virtual host' do
    action :run
    command "rm -rf #{node[:apache][:dir]}/sites-enabled/*"
  end
  # create folder
  directory "#{node[:apache][:dir]}/sites-enabled" do
    mode 0755
    owner 'root'
    group 'root'
    action :create
  end

  include_recipe 'apache2'
  include_recipe 'apache2::mod_rewrite'
  include_recipe 'apache2::mod_deflate'
  include_recipe 'apache2::mod_headers'
  application_name = 'default'

  directory "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d"
  params[:application_name] = application_name,
  params[:docroot] = '/var/www/html',
  params[:server_name] = '127.0.0.1',
  params[:rewrite_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/rewrite",
  params[:local_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/local"

  template "#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf" do
    Chef::Log.debug("Generating Apache site template for #{application_name.inspect}")
    group 'root'
    source 'web_app.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :application_name => application_name,
      :params => params,
      :environment => nil
    )
    if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :reload, "service[apache2]", :delayed
    end
  end
  
  # Restart apache
  apache_site "#{application_name}.conf" do
    enable enable_setting
  end

  execute "echo 'short_open_tag = On' >> /etc/php.ini"
  execute "echo 'display_errors = On' >> /etc/php.ini"
  execute "echo 'error_reporting = E_ERROR & ~E_DEPRECATED & ~E_STRICT' >> /etc/php.ini"
  # start apache
  execute "sed -i 's/AllowOverride none/AllowOverride All/g' /etc/httpd/conf/httpd.conf"
  execute "sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf"

  # start apache
  execute 'sudo apachectl start'
  execute 'sudo apachectl restart'
end
