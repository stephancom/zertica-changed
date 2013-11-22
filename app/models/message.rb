class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin

  validates :user, presence: true
  validates :body, presence: true
  # validate user owns project or is admin?

  default_scope {order('created_at ASC').includes(:user, :admin)}
  scope :bookmarked, -> { where(bookmark: true) }

  delegate :name, to: :admin, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true

  after_create :notify_admins, if: Proc.new { |message| message.admin.nil? and message.user.notify_on_next_message }

  def speaker_name
  	admin_id ? (admin_name || 'zertica staff') : (user_name || 'deleted user')
  end

  def notify_admins
    MessageNotifications.message_from_user(self).deliver
    user.notify_on_next_message = false
    user.save
  end
end
