require 'spec_helper'

describe MonitorJob do
  describe :perform do
    it "should run a check for each service on each host" do
      a_host = double "Host"
      a_service = double "Service"
      Host.should_receive(:all).and_return [ a_host ]
      a_host.should_receive(:services).and_return [ a_service ]
      a_service.should_receive(:perform_check)
      MonitorJob.new.perform
    end
  end
end