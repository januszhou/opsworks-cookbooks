node[:deploy].each do |application, deploy|
  Dir.foreach('/var/www/codebase') do |folder|
    next if item == '.' or item == '..'
    git "/var/www/codebase/#{folder}" do
      action :sync
    end
  end
end