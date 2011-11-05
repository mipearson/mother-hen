require 'spec_helper'

describe MHConfig do

  FIXTURE = <<-EOF
    host 'localhost', :services => [:dummy]
    email 'mipearson@gmail.com'
    frequency 1.minute

    service :dummy do
      local do
        'hello'
      end
    end
  EOF
  
  describe :parse do
    before :all do
      MHConfig.parse FIXTURE
    end
    
    subject { MHConfig }
    
    it { subject.hosts.keys.length.should == 1 }
    it { subject.hosts.keys.should include 'localhost' }
    it { subject.services.keys.length.should == 1 }
    it { subject.services.keys.should include :dummy }
    it { subject.frequency.should == 1.minute }
    it { subject.email.should == 'mipearson@gmail.com' }
    
    context "host" do
      subject { MHConfig.hosts['localhost'] }
      
      it { subject.services.should == [:dummy] }
      it { subject.name.should == 'localhost' }
      it { subject.hostname.should == 'localhost' }
    end
    
    context "service" do
      subject { MHConfig.services[:dummy] }
      
      it { subject.name.should == :dummy }
      it { subject.local.call.should == 'hello' }
    end
  end
end
    