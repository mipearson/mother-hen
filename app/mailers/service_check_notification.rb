class ServiceCheckNotification < ActionMailer::Base
  default from: "no-reply@" + `hostname -f`.chomp

  def failure service_check_job
    @service_check_job = service_check_job

    mail :to => SlimConfiguration.email, :subject => "Service #{service_check_job.service} failed on #{service_check_job.host}"
  end
end
