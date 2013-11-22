require "spec_helper"

describe OrderNotifications do
  describe "new_order" do
    let(:mail) { OrderNotifications.new_order }

    it "renders the headers" do
      mail.subject.should eq("New order")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "estimate" do
    let(:mail) { OrderNotifications.estimate }

    it "renders the headers" do
      mail.subject.should eq("Estimate")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "thank_you" do
    let(:mail) { OrderNotifications.thank_you }

    it "renders the headers" do
      mail.subject.should eq("Thank you")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "paid" do
    let(:mail) { OrderNotifications.paid }

    it "renders the headers" do
      mail.subject.should eq("Paid")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "complete" do
    let(:mail) { OrderNotifications.complete }

    it "renders the headers" do
      mail.subject.should eq("Complete")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "shipped" do
    let(:mail) { OrderNotifications.shipped }

    it "renders the headers" do
      mail.subject.should eq("Shipped")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
