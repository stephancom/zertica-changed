require 'spec_helper'

describe "orders/show" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :type => "Type",
      :project => nil,
      :state => "State",
      :title => "Title",
      :description => "MyText",
      :price => "9.99",
      :tracking_number => "Tracking Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    rendered.should match(//)
    rendered.should match(/State/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/9.99/)
    rendered.should match(/Tracking Number/)
  end
end
