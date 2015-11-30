node[:deploy].each do |application, deploy|
  application_name = 'default'

  directory "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d"

  template "#{node[:apache][:dir]}/sites-enabled/default.conf" do
    Chef::Log.debug("Generating Apache site template for #{application_name.inspect}")
    group 'root'
    source 'web_app.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :application_name => application_name,
      :docroot => '/srv/www/html'
    )
    if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :reload, "service[apache2]", :delayed
    end
  end
  apache_site "#{application_name}.conf" do
    enable enable_setting
  end
end