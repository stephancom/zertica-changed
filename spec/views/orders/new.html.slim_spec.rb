require 'spec_helper'

describe "orders/new" do
  before(:each) do
    assign(:order, stub_model(Order,
      :type => "",
      :project => nil,
      :state => "MyString",
      :title => "MyString",
      :description => "MyText",
      :price => "9.99",
      :tracking_number => "MyString"
    ).as_new_record)
  end

  it "renders new order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", orders_path, "post" do
      assert_select "input#order_type[name=?]", "order[type]"
      assert_select "input#order_project[name=?]", "order[project]"
      assert_select "input#order_state[name=?]", "order[state]"
      assert_select "input#order_title[name=?]", "order[title]"
      assert_select "textarea#order_description[name=?]", "order[description]"
      assert_select "input#order_price[name=?]", "order[price]"
      assert_select "input#order_tracking_number[name=?]", "order[tracking_number]"
    end
  end
end
