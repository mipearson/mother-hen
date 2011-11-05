module MotherHen
  class Daemon
    def self.start
      Rails.logger.info "Starting daemon..."
      while true do
        begun_at = Time.now
        MHConfig.hosts.each do |host_name, host|
          host.services.each do |service_name|
            begun_check_at = Time.now
            check = ServiceCheckJob.new(:service => service_name, :host => host_name)
            check.perform
            message = "ServiceCheck: #{host_name}/#{service_name} status: #{check.status} took #{Time.now - begun_check_at} seconds"
            if check.ok?
              Rails.logger.info message
            else
              Rails.logger.warn message
            end
          end
        end
        delta = begun_at + MHConfig.frequency - Time.now
        if delta > 0
          Rails.logger.debug("Sleeping for #{delta} seconds")
          sleep(delta)
        else
          Rails.logger.warn("Service checks took #{delta * -1} seconds longer than frequency setting, consider adjusting")
        end
      end
    end
      
  end
end