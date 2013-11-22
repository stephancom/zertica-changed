require "spec_helper"

describe MessageNotifications do
  describe "new_message" do
    let(:mail) { MessageNotifications.new_message }

    it "renders the headers" do
      mail.subject.should eq("New message")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
