namespace :mother_hen do
  
  task :configuration do
    config_file = ENV['MH_CONFIG'] || Rails.root.join('config', 'mother_hen.rb')
    MHConfig.parse(File.read(config_File))
  end
  
  desc "Run service checks until killed"
  task :start => :configuration do
    require 'lib/mother_hen/daemon'
    MotherHen::Daemon.start
  end
end
      
    
  