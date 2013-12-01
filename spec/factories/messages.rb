# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    body "MyText"
    user
    admin nil
  end
end
