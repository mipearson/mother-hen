require 'spec_helper'

describe MonitorController do
  describe :run do
    it "should create a new MonitorJob and run it " do
      monitor = double('Monitor')
      MonitorJob.should_receive(:new).and_return(monitor)
      monitor.should_receive(:perform)
      get :run
    end
  end
end
  