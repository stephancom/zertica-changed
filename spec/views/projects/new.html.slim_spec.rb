require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, build(:project))

  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projects_path, "post" do
      assert_select "input#project_title[name=?]", "project[title]"
      assert_select "textarea#project_spec[name=?]", "project[spec]"
    end
  end
end
