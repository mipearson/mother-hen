require 'spec_helper'

describe SlimConfiguration do

  FIXTURE = <<-EOF
    host 'localhost', :services => [:dummy]
    email 'mipearson@gmail.com'

    service :dummy do
      local do
        'hello'
      end
    end
  EOF
  
  describe :parse do
    before :all do
      SlimConfiguration.parse FIXTURE
    end
    
    subject { SlimConfiguration }
    
    it { subject.hosts.keys.length.should == 1 }
    it { subject.hosts.keys.should include 'localhost' }
    it { subject.services.keys.length.should == 1 }
    it { subject.services.keys.should include :dummy }
    it { subject.email.should == 'mipearson@gmail.com' }
    
    context "host" do
      subject { SlimConfiguration.hosts['localhost'] }
      
      it { subject.services.should == [:dummy] }
      it { subject.name.should == 'localhost' }
      it { subject.hostname.should == 'localhost' }
    end
    
    context "service" do
      subject { SlimConfiguration.services[:dummy] }
      
      it { subject.name.should == :dummy }
      it { subject.local.call.should == 'hello' }
    end
  end
end
    