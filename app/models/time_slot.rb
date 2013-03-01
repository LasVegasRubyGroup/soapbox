class TimeSlot < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :topic
  belongs_to :presenter, class_name: 'User'

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :meeting_id, presence: true
  # validates :topic_id, presence: true
  # validates :presenter_id, presence: true

  attr_accessible :topic_id, :ends_at, :meeting_id, :presenter_id, :starts_at

  def give_points
    topic.give_points_to(presenter)
  end
end
