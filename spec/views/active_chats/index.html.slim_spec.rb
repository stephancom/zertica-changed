require 'spec_helper'

describe "active_chats/index" do
  before(:each) do
    assign(:active_chats, [
      stub_model(ActiveChat,
        :user => nil,
        :admin => nil
      ),
      stub_model(ActiveChat,
        :user => nil,
        :admin => nil
      )
    ])
  end

  it "renders a list of active_chats" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
