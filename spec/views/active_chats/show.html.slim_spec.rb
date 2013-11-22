require 'spec_helper'

describe "active_chats/show" do
  before(:each) do
    @active_chat = assign(:active_chat, stub_model(ActiveChat,
      :user => nil,
      :admin => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
