require 'spec_helper'

describe "bids/new" do
  before(:each) do
    assign(:bid, stub_model(Bid).as_new_record)
  end

  it "renders new bid form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bids_path, "post" do
    end
  end
end
