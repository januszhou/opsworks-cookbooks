node[:deploy].each do |application, deploy|
	link '/srv/www/skyphp' do
  	to '/var/www/skyphp'
  	link_type :symbolic
	end
end