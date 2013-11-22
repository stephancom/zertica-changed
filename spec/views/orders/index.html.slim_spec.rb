require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :type => "Type",
        :project => nil,
        :state => "State",
        :title => "Title",
        :description => "MyText",
        :price => "9.99",
        :tracking_number => "Tracking Number"
      ),
      stub_model(Order,
        :type => "Type",
        :project => nil,
        :state => "State",
        :title => "Title",
        :description => "MyText",
        :price => "9.99",
        :tracking_number => "Tracking Number"
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Tracking Number".to_s, :count => 2
  end
end
