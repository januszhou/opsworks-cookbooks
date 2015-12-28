node[:deploy].each do |application, deploy|
	base = "/srv/www/carve_cart/current"

	# install bower dependencies
	execute "#{base}/node_modules/bower/bin/bower install"

	# link up into public
	link "#{base}/public/bower_components" do
		to "#{base}/bower_components"
	end
end