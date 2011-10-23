class MonitorController < ApplicationController
  def run
    MonitorJob.new.perform
  end
end
