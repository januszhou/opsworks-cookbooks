node[:deploy].each do |application, deploy|

  fullLists = {
    'skyphp' => { 'url' => 'git@github.com:SkyPHP/skyphp.git', 'branch' => '3.0-beta' },
    'cms' => { 'url' => 'git@github.com:SkyPHP/cms.git', 'branch' => '3.0' },
    'crave-deploy' => { 'url' => 'git@github.com:SkyPHP/crave-deploy.git', 'branch' => 'master' },
    'crave-event' => { 'url' => 'git@github.com:SkyPHP/crave-event.git', 'branch' => 'master' },
    'crave-inc' => { 'url' => 'git@github.com:SkyPHP/crave-inc.git', 'branch' => '3.0' },
    'crave-reseller' => { 'url' => 'git@github.com:SkyPHP/crave-reseller.git', 'branch' => '3.5' },
    'crave-sites' => { 'url' => 'git@github.com:SkyPHP/crave-sites.git', 'branch' => 'master' },
    'crave-templates' => { 'url' => 'git@github.com:SkyPHP/crave-templates.git', 'branch' => 'master' },
    'cravetix' => { 'url' => 'git@github.com:SkyPHP/cravetix.git', 'branch' => '3.0' },
    'downtowncountdown.net' => { 'url' => 'git@github.com:SkyPHP/downtowncountdown.net.git', 'branch' => 'master' },
    'halloweenparties.com' => { 'url' => 'git@github.com:SkyPHP/halloweenparties.com.git', 'branch' => 'master' },
    'jb-inc' => { 'url' => 'git@github.com:SkyPHP/jb-inc.git', 'branch' => '3.0' },
    'jb-production' => { 'url' => 'git@github.com:SkyPHP/jb-production.git', 'branch' => 'aws' },
    'joonbug-v3' => { 'url' => 'git@github.com:SkyPHP/joonbug-v3.git', 'branch' => 'master' },
    'lindys' => { 'url' => 'git@github.com:SkyPHP/lindys.git', 'branch' => 'master' },
    'newyears.com' => { 'url' => 'git@github.com:SkyPHP/newyears.com.git', 'branch' => 'master' },
    'newyearseve.com' => { 'url' => 'git@github.com:SkyPHP/newyearseve.com.git', 'branch' => 'master' },
    'newyearsevecentral.com' => { 'url' => 'git@github.com:SkyPHP/newyearsevecentral.com.git', 'branch' => 'master' },
    'nyephilly' => { 'url' => 'git@github.com:SkyPHP/nyephilly.git', 'branch' => 'master' },
    'timessquarenewyears3' => { 'url' => 'git@github.com:SkyPHP/timessquarenewyears3.git', 'branch' => 'master' },
    'barcrawls' => { 'url' => 'git@github.com:SkyPHP/barcrawls.git', 'branch' => '3.0' },
    'vipclubtour' => { 'url' => 'git@github.com:SkyPHP/vipclubtour.git', 'branch' => 'master' }
  }

  if Dir.exists?('/var/www/codebases')
    fullLists.each do |name, detail|
      git "/var/www/codebases/#{name}" do
        repository detail['url']
        checkout_branch detail['branch']
        enable_submodules true
        action :sync
        revision detail['branch']
        enable_checkout false
        ssh_wrapper "/root/git_wrapper.sh"
      end
    end
  end
  
  if Dir.exists?('/var/www/codebases')
    Dir.foreach('/var/www/codebases') do |folder|
      next if folder == '.' or folder == '..'
      execute "git checkout #{fullLists[folder]['branch']}" do
        cwd "/var/www/codebases/#{folder}"
      end
    end
  end
  
       
end
