node[:deploy].each do |application, deploy|
  execute "echo 'short_open_tag = On' >> /etc/php.ini"
  execute "echo 'display_errors = On' >> /etc/php.ini"
  # start apache
  execute 'sudo apachectl start'
  execute 'sudo apachectl restart'
end