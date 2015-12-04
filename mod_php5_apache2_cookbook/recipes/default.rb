case node[:platform]

  when "rhel", "fedora", "suse", "centos", "amazon"

    if node['platform_version'].to_f >= 7
      # add the EPEL repo
      yum_repository 'epel' do
        description 'Extra Packages for Enterprise Linux'
        mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64'
        gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
        action :create
      end

      # add the webtatic repo
      yum_repository 'webtatic' do
        description 'webtatic Project'
        mirrorlist 'http://repo.webtatic.com/yum/el7/x86_64/mirrorlist'
        gpgkey 'http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7'
        action :create
      end

      node.set['apache']['version'] = '2.4'
      node.set['apache']['package'] = 'httpd'
     else
      # add the EPEL repo
      yum_repository 'epel' do
        description 'Extra Packages for Enterprise Linux'
        mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=x86_64'
        gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
        action :create
      end

      # add the webtatic repo
      yum_repository 'webtatic' do
        description 'webtatic Project'
        mirrorlist 'http://repo.webtatic.com/yum/el6/x86_64/mirrorlist'
        gpgkey 'http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-andy'
        action :create
      end

      node.set['apache']['version'] = '2.2'
      node.set['apache']['package'] = 'httpd'
    end



    node.set['php']['packages'] = ['php54', 'php54-devel', 'php54-cli', 'php54-snmp', 'php54-soap', 'php54-xml', 'php54-xmlrpc', 'php54-process', 'php54-mysqlnd', 'php54-pecl-memcache', 'php54-opcache', 'php54-pdo', 'php54-imap', 'php54-mbstring', 'php54-intl', 'php54-mcrypt']

    include_recipe "build-essential"
    include_recipe "apache2::default"
    include_recipe "apache2::mod_rewrite"
    include_recipe "php"
end