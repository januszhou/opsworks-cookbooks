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
    'nyephilly' => { 'url' => 'git@github.com:SkyPHP/nyephilly.git', 'branch' => '3.0-beta' },
    'timessquarenewyears3' => { 'url' => 'git@github.com:SkyPHP/timessquarenewyears3.git', 'branch' => 'master' }
  }
  Dir.foreach('/var/www/codebases') do |folder|
    next if folder == '.' or folder == '..'
    git "/var/www/codebases/#{folder}" do
      repository fullLists[folder][:url]
      revision fullLists[folder][:branch]
      action :sync
      ssh_wrapper "/root/git_wrapper.sh"
    end
  end
end