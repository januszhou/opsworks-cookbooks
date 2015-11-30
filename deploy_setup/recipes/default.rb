node[:deploy].each do |application, deploy|
  include_recipe 'apache2'
  include_recipe 'apache2::mod_rewrite'
  include_recipe 'apache2::mod_deflate'
  include_recipe 'apache2::mod_headers'
  application_name = 'default'

  directory "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d"
  params[:application_name] = application_name,
  params[:docroot] = '/srv/www/html',
  params[:server_name] = '127.0.0.1',
  params[:rewrite_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/rewrite",
  params[:local_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/local"

  template "#{node[:apache][:dir]}/sites-enabled/default.conf" do
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
end