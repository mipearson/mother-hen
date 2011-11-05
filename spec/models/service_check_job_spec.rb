require 'spec_helper'

describe ServiceCheckJob do
  context "with a valid service and host" do
    before :each do
      @a_host = double('Host', :hostname => 'my_hostname')
      @a_service = double('Service')
      MHConfig.stub!(:services => {:a_service => @a_service}, :hosts => {'a_host' => @a_host} )
      @job = ServiceCheckJob.new(:service => :a_service, :host => 'a_host')   
    end
    
    context "with a successful service check" do      
      it "should set the status to 'OK' after running the check and save" do
        @a_service.should_receive(:local).and_return( lambda {|hostname| hostname })
        @job.should_receive(:save!)
        @job.perform
        @job.result.should == 'my_hostname'
        @job.status.should == 'OK'
        @job.ok?.should be_true
      end
    end
    
    context "with a failed service check" do
      
      it "should set status to 'Failed', after running the check, save and send notification" do
        @a_service.should_receive(:local).and_return( lambda {|hostname| raise "aaaargh #{hostname}"})       
        @job.should_receive(:save!)
        mailer = double('Notifier')
        mailer.should_receive(:deliver)
        ServiceCheckNotification.should_receive(:failure).with(@job).and_return(mailer)
        
        @job.perform
        @job.ok?.should be_false
        @job.status.should == 'Failure'
        @job.result.should =~ /RuntimeError.+aargh my_hostname/        
      end
    end
  end
end
