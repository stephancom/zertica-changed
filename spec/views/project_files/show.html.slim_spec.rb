require 'spec_helper'

describe "project_files/show" do
  before(:each) do
    @project_file = assign(:project_file, stub_model(ProjectFile,
      :project => nil,
      :url => "Url",
      :data => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Url/)
    rendered.should match(//)
  end
end
