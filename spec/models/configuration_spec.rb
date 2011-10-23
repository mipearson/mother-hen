require 'spec_helper'

describe Configuration do

  FIXTURE = <<-EOF
    host 'localhost', :services => [:dummy]

    service :dummy do
      ruby_block do
        'hello'
      end
    end
  EOF
  
  describe :parse do
    before :all do
      Configuration.parse FIXTURE
    end
    
    subject { Configuration }
    
    it { subject.hosts.keys.length.should == 1 }
    it { subject.hosts.keys.should include 'localhost' }
    it { subject.services.keys.length.should == 1 }
    it { subject.services.keys.should include :dummy }
    
    context "host" do
      subject { Configuration.hosts['localhost'] }
      
      it { subject.services.should == [:dummy] }
      it { subject.name.should == 'localhost' }
      it { subject.hostname.should == 'localhost' }
    end
    
    context "service" do
      subject { Configuration.services[:dummy] }
      
      it { subject.name.should == :dummy }
      it { subject.ruby_block.call.should == 'hello' }
    end
  end
end
    