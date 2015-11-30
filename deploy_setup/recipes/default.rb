Chef::Log.info("******Creating a data directory.******")
node[:deploy].each do |application, deploy|
  link '/var/www/skyphp' do
    to '/srv/www/skyphp'
    link_type :symbolic
  end
end