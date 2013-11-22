require 'spec_helper'

describe "project_files/new" do
  before(:each) do
    assign(:project_file, stub_model(ProjectFile,
      :project => nil,
      :url => "MyString",
      :data => ""
    ).as_new_record)
  end

  it "renders new project_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_files_path, "post" do
      assert_select "input#project_file_project[name=?]", "project_file[project]"
      assert_select "input#project_file_url[name=?]", "project_file[url]"
      assert_select "input#project_file_data[name=?]", "project_file[data]"
    end
  end
end
