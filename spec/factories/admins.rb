FactoryGirl.define do
	factory :admin do
		name 'Test Admin'
		sequence(:email) {|n| "adminemail#{n}@example.com" }
		password 'AdminZerotica!'
		password_confirmation 'AdminZerotica!'
		# required if the Devise Confirmable module is used
		# confirmed_at Time.now
	end
end
