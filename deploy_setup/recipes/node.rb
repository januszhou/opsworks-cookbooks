node[:deploy].each do |application, deploy|
	base = "/srv/www/carve_cart"
	current = "#{base}/current"

	# install bower dependencies
	execute "#{current}/node_modules/bower/bin/bower install --allow-root" do
		cwd current
	end

	# link up into public
	link "#{current}/public/bower_components" do
		to "#{current}/bower_components"
	end
end