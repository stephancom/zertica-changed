FactoryGirl.define do
	factory :user do
		name 'Test User'
		sequence(:email) {|n| "email#{n}@example.com" }
		password 'Zerotica!'
		password_confirmation 'Zerotica!'
		# required if the Devise Confirmable module is used
		# confirmed_at Time.now
	end
end
