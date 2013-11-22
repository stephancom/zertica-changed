# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    type ""
    project nil
    state "MyString"
    title "MyString"
    description "MyText"
    price "9.99"
    tracking_number "MyString"
  end
end
