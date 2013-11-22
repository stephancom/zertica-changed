namespace :zertica do
  desc "Send new message notifications"
  task new_messages: :environment do
  	User.all.find_each(&:notify_if_new_message)
  end
end
