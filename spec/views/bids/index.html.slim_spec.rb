require 'spec_helper'

describe "bids/index" do
  before(:each) do
    assign(:bids, [
      stub_model(Bid),
      stub_model(Bid)
    ])
  end

  it "renders a list of bids" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
