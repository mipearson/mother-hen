namespace :mother_hen do
  
  task :configuration do
    config_file = ENV['MH_CONFIG'] || Rails.root.join('config', 'mother_hen.rb'))
    MHConfig.parse(File.read(config_File))
  end
  
  desc "Run service checks until killed"
  task :start => :configuration do
    MotherHen::Daemon.start
  end
    while true do
      begun_at = Time.now
      MHConfig.hosts.each do |host_name, host|
        host.services.each do |service_name|
          MHConfig.services[service_name] do
            begun_check_at = Time.now
            check = ServiceCheckJob.new(:service => :service_name, :host => :host_name)
            check.perform
            message = "ServiceCheck: #{host_name}/#{service_name} status: #{check.status} took #{Time.now - begun_check_at} seconds"
            if check.ok?
              Rails.logger.info message
            else
              Rails.logger.warn message
            end
          end
        end
      end
      delta = MHConfig.frequency + begun_at - Time.now
      if delta > 0
        Rails.logger.debug("Sleeping for #{delta} seconds")
        sleep(delta)
      else
        Rails.logger.warn("Service checks took #{delta * -1} seconds longer than frequency setting, consider adjusting")
      end
    end
  end
end
      
    
  