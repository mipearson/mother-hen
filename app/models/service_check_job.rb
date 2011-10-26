class ServiceCheckJob < ActiveRecord::Base
  def perform
    service_config = Configuration.services[service]
    begin
      service_config.local.call
      self.status = 'OK'
    rescue => e
      self.status = 'Failure'
    end
    save!
  end
end
