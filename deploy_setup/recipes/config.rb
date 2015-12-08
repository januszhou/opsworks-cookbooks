node[:deploy].each do |application, deploy|
  execute "echo 'short_open_tag = On' >> /etc/php.ini"
  execute "echo 'display_errors = On' >> /etc/php.ini"
  execute "echo 'error_reporting = E_ERROR & ~E_DEPRECATED & ~E_STRICT' >> /etc/php.ini"
  # start apache
  execute "sed -i 's/AllowOverride none/AllowOverride All/g' /etc/httpd/conf/httpd.conf"
  execute "sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf"
  execute 'sudo service httpd start'
  execute 'sudo service httpd restart'
end