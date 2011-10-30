require "spec_helper"

describe ServiceCheck do
  describe "failed" do
    let(:mail) { ServiceCheck.failed }

    it "renders the headers" do
      mail.subject.should eq("Failed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
