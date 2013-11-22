require 'spec_helper'

describe "projects/show" do
  before(:each) do
    @project = assign(:project, create(:project))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/New Project/)
    rendered.should match(/preparing/)
    rendered.should match(//)
    rendered.should match(/This is my project/)
  end
end
