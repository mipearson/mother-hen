class ServiceCheckJob < ActiveRecord::Base
  def perform
    service_config = MHConfig.services[service]
    host_config = MHConfig.hosts[host]
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
  
  def ok?
    self.status == 'OK'
  end
end
