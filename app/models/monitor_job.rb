class MonitorJob
  def perform
    Host.all.each do |host|
      host.services.each(&:perform_check)
    end
  end 
end