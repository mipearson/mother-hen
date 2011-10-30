require "spec_helper"

describe ServiceCheckNotification do
  describe "failure" do
    before :each do
      @service_check_job = ServiceCheckJob.new(:service => :dummy_service, :host => :dummy_host)
      
      SlimConfiguration.stub!(:email => 'my_email@gmail.com')
    end
    
    let(:mail) { ServiceCheckNotification.failure(@service_check_job) }
    
    it "should mail the recipient configured" do
      mail.to.should == ['my_email@gmail.com']
    end
    
    it "should contain the service / host name in the mail subject and body" do
      mail.body.should match 'dummy_host'
      mail.body.should match 'dummy_service'
      mail.subject.should match 'dummy_host'
      mail.subject.should match 'dummy_service'
    end
    
    

  #   it "renders the headers" do
  #     mail.subject.should eq("Failed")
  #     mail.to.should eq(["to@example.org"])
  #     mail.from.should eq(["from@example.com"])
  #   end
  # 
  #   it "renders the body" do
  #     mail.body.encoded.should match("Hi")
  #   end
  end

end
