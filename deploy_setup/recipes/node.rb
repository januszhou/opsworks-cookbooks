node[:deploy].each do |application, deploy|
	base = "/srv/www/crave_cart"
	directory "#{base}/current"

	# install bower dependencies
	execute "node_modules/bower/bin/bower install"

	# link up into public
	link "public/bower_components" do
		to "bower_components"
	end
end