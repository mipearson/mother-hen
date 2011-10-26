class ServiceCheckController < ApplicationController
  def index
    @service_check_jobs = ServiceCheckJobs.all
  end
end