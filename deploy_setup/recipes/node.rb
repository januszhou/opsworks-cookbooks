node[:deploy].each do |application, deploy|
	base = "/srv/www/carve_cart/current"

	execute "cd #{base}"
	# install bower dependencies
	execute "node_modules/bower/bin/bower install --allow-root"

	# link up into public
	link "public/bower_components" do
		to "bower_components"
	end
end