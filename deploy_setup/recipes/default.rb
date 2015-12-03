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

  {
    "/srv/www/skyphp/current" => "skyphp", 
    "/srv/www/cms/current" => "cms", 
    "/srv/www/crave_deploy/current" => "crave-deploy", 
    "/srv/www/crave_event/current" => "crave-event", 
    "/srv/www/crave_inc/current" => "crave-inc",
    "/srv/www/crave_reseller/current" => "crave-reseller",
    "/srv/www/crave_sites/current" => "crave-sites",
    "/srv/www/crave_templates/current" => "crave-templates",
    "/srv/www/cravetix/current" => "cravetix",
    "/srv/www/downtowncountdownnet/current" => "downtowncountdown.net",
    "/srv/www/halloweenpartiescom/current" => "halloweenparties.com",
    "/srv/www/jb_inc/current" => "jb-inc",
    "/srv/www/jb_production/current" => "jb-production",
    "/srv/www/joonbug_v3/current" => "joonbug-v3",
    "/srv/www/lindys/current" => "lindys",
    "/srv/www/newyearscom/current" => "newyears.com",
    "/srv/www/newyearsevecom/current" => "newyearseve.com",
    "/srv/www/newyearsevecentralcom/current" => "newyearsevecentral.com",
    "/srv/www/nyephilly/current" => "nyephilly",
    "/srv/www/timessquarenewyears3/current" => "timessquarenewyears3"
  }.each do |path, name|
    link "/var/www/#{name}" do
      to path
    end
  end

  directory "/var/www" do
    mode 0755
    owner 'deploy'
    group 'www-data'
    recursive true
    action :create
  end
end