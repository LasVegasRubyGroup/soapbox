class TimeSlot < ActiveRecord::Base
  belongs_to :topic
  belongs_to :presenter, class_name: 'User'

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :topic_id, presence: true
  validates :presenter_id, presence: true

  attr_accessible :ends_at, :presenter_id, :starts_at

  def give_points
    topic.give_points_to(presenter)
  end
end
