class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin
  belongs_to :speaker, polymorphic: :true

  validates :user, presence: true
  validates :admin, presence: true
  validates :body, presence: true

  default_scope {order('created_at ASC').includes(:user, :admin)}

  delegate :name, to: :admin, prefix: true
  delegate :name, to: :user, prefix: true
  delegate :name, to: :speaker, prefix: true, allow_nil: true
end
