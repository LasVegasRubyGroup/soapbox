class Kudo < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  attr_accessible :user, :topic

  validates_uniqueness_of :user_id, scope: :topic_id, message: 'has already submitted their Kudo'
end
