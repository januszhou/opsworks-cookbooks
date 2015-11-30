node[:deploy].each do |application, deploy|
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

  # Create /var/www, and assign it to deploy:www-data
  directory "/var/www" do
    mode 0755
    owner 'deploy'
    group 'www-data'
    recursive true
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
  apache_site "#{application_name}.conf" do
    enable enable_setting
  end

  link '/var/www/skyphp' do
    to '/srv/www/skyphp/current'
  end

  link '/var/www/cms' do
    to '/srv/www/cms/current'
  end

  directory "/var/www" do
    mode 0755
    owner 'deploy'
    group 'www-data'
    recursive true
    action :create
  end
end