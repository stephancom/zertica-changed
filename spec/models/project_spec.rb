require 'spec_helper'

describe Project do
	it "should require a title" do
		build(:project, title: '').should_not be_valid
	end
end
