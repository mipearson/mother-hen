class ServiceCheckJob < ActiveRecord::Base
  def perform
    service_config = SlimConfiguration.services[service]
    host_config = SlimConfiguration.hosts[host]
    begin
      self.result = service_config.local.call host_config.hostname
      self.status = 'OK'
    rescue => e
      self.status = 'Failure'
      self.result = e.inspect
      ServiceCheckNotification.failure(self).deliver
    end
    save!
  end
end
