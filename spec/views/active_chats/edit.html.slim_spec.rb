require 'spec_helper'

describe "active_chats/edit" do
  before(:each) do
    @active_chat = assign(:active_chat, stub_model(ActiveChat,
      :user => nil,
      :admin => nil
    ))
  end

  it "renders the edit active_chat form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", active_chat_path(@active_chat), "post" do
      assert_select "input#active_chat_user[name=?]", "active_chat[user]"
      assert_select "input#active_chat_admin[name=?]", "active_chat[admin]"
    end
  end
end
