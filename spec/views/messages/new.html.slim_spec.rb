require 'spec_helper'

describe "messages/new" do
  before(:each) do
    assign(:message, stub_model(Message,
      :body => "MyText",
      :project => nil,
      :user => nil,
      :bookmark => false
    ).as_new_record)
  end

  it "renders new message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", messages_path, "post" do
      assert_select "textarea#message_body[name=?]", "message[body]"
      assert_select "input#message_project[name=?]", "message[project]"
      assert_select "input#message_user[name=?]", "message[user]"
      assert_select "input#message_bookmark[name=?]", "message[bookmark]"
    end
  end
end
