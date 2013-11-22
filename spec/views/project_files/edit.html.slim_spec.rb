require 'spec_helper'

describe "project_files/edit" do
  before(:each) do
    @project_file = assign(:project_file, stub_model(ProjectFile,
      :project => nil,
      :url => "MyString",
      :data => ""
    ))
  end

  it "renders the edit project_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_file_path(@project_file), "post" do
      assert_select "input#project_file_project[name=?]", "project_file[project]"
      assert_select "input#project_file_url[name=?]", "project_file[url]"
      assert_select "input#project_file_data[name=?]", "project_file[data]"
    end
  end
end
