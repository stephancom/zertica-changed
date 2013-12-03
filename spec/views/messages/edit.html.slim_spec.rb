require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :body => "MyText",
      :project => nil,
      :user => nil
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", message_path(@message), "post" do
      assert_select "textarea#message_body[name=?]", "message[body]"
      assert_select "input#message_project[name=?]", "message[project]"
      assert_select "input#message_user[name=?]", "message[user]"
    end
  end
end
