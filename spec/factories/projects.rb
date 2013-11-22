# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title "New Project"
    user
    spec "This is my project"
    deadline "2013-09-14 00:28:07"
  end
end
