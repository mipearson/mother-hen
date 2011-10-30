class ServiceCheckJob < ActiveRecord::Base
  def perform
    service_config = Configuration.services[service]
    host_config = Configuration.hosts[host]
    begin
      self.result = service_config.local.call host_config.hostname
      self.status = 'OK'
    rescue => e
      self.status = 'Failure'
      self.result = e.inspect
    end
    save!
  end
end
