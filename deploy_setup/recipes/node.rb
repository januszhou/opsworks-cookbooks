node[:deploy].each do |application, deploy|
	base = "/srv/www/carve_cart/current"

	directory "#{base}/current"

	execute "cd #{base}/current"

	# install bower dependencies
	execute "#{base}/node_modules/bower/bin/bower install --allow-root"

	# link up into public
	link "public/bower_components" do
		to "bower_components"
	end
end