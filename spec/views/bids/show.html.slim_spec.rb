require 'spec_helper'

describe "bids/show" do
  before(:each) do
    @bid = assign(:bid, stub_model(Bid))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
