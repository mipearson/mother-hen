require 'spec_helper'

describe ServiceCheckJob do
  context "with a valid service and host" do
    before :each do
      a_host = double('Host')
      @a_service = double('Service')
      Configuration.stub!(:services => {:a_service => @a_service}, :hosts => {'a_host' => @a_host} )
      @job = ServiceCheckJob.new(:service => :a_service, :host => 'a_host')   
    end
    
    
    context "with a successful service check" do      
      it "should set the status to 'OK' after running the check and save" do
        @a_service.should_receive(:local).and_return( lambda {'a service'})
        @job.should_receive(:save!)
        @job.perform
        @job.status.should == 'OK'
      end
    end
    
    context "with a failed service check" do
      
      it "should set status to 'Failed' after running the check and save" do
        @a_service.should_receive(:local).and_return( lambda {raise 'aaaargh'})       
        @job.should_receive(:save!)
        @job.perform
        @job.status.should == 'Failure'
      end
    end
  end
end
