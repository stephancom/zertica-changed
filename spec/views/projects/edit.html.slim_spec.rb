require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, create(:project))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_path(@project), "post" do
      assert_select "input#project_title[name=?]", "project[title]"
      assert_select "textarea#project_spec[name=?]", "project[spec]"
    end
  end
end
