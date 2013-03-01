class Voter < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  validates :user_id, presence: true, uniqueness: { scope: :topic_id }
  validates :topic_id, presence: true

  attr_accessible :topic_id, :user_id

  def name
    user.name
  end
end
