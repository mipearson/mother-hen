class ServiceCheckController < ApplicationController
  def index
    @service_check_jobs = ServiceCheckJob.all
    # $stderr.puts @service_check_jobs.inspect
  end
end