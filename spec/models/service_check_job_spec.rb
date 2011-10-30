require 'spec_helper'

describe ServiceCheckJob do
  context "with a valid service and host" do
    before :each do
      @a_host = double('Host', :hostname => 'my_hostname')
      @a_service = double('Service')
      Configuration.stub!(:services => {:a_service => @a_service}, :hosts => {'a_host' => @a_host} )
      @job = ServiceCheckJob.new(:service => :a_service, :host => 'a_host')   
    end
    
    context "with a successful service check" do      
      it "should set the status to 'OK' after running the check and save" do
        @a_service.should_receive(:local).and_return( lambda {|hostname| hostname })
        @job.should_receive(:save!)
        @job.perform
        @job.status.should == 'OK'
        @job.result.should == 'my_hostname'
      end
    end
    
    context "with a failed service check" do
      
      it "should set status to 'Failed' after running the check and save" do
        @a_service.should_receive(:local).and_return( lambda {|hostname| raise "aaaargh #{hostname}"})       
        @job.should_receive(:save!)
        @job.perform
        @job.status.should == 'Failure'
        @job.result.should =~ /RuntimeError.+aargh my_hostname/
      end
    end
  end
end
