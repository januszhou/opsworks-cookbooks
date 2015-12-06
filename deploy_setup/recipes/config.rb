node[:deploy].each do |application, deploy|
  # start apache
  execute 'sudo apachectl start'
  execute 'sudo apachectl restart'
end