node[:deploy].each do |application, deploy|
	base = "/srv/www/carve_cart"
	current = "#{base}/current"

	execute "cd #{base}"

	# install bower dependencies
	execute "#{current}/node_modules/bower/bin/bower install #{current}/bower.json --allow-root"

	# link up into public
	link "#{current}/public/bower_components" do
		to "bower_components"
	end
end