class Volunteer < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  validates :user_id, presence: true, uniqueness: { scope: :topic_id }
  validates :topic_id, presence: true

  attr_accessible :user_id, :topic_id

  def name
    user.name
  end
end
