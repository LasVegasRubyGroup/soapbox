class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting
  has_many :voters
  has_many :volunteers

  validates :title, presence: true
  validates :description, presence: true

  attr_accessible :description, :meeting_id, :state, :title

  state_machine initial: :open do
    state :open
    state :selected
    state :closed

    event :select do
      transition to: :selected, from: [:open]
    end

    event :close do
      transition to: :closed, from: [:selected]
    end
  end

  def self.open_by_votes
    select('topics.*, COUNT(voters.id) AS votes')
    .joins(:voters)
    .with_state(:open)
    .group('topics.id')
    .order('votes DESC')
  end

  def self.by_most_recent
    order('created_at DESC')
  end

  def give_points_to(presenter)
    [
      { name: user.name, points: user.earn_points!(suggestion_points) },
      { name: presenter.name, points: presenter.earn_points!(presenter_points)}
    ]
  end

  def votes
    voters.count
  end

  alias :points :votes

  def mark_as_selected!(meeting)
    self.update_attribute(meeting_id: id)
    select!
  end

  def suggestion_points
    points / 4
  end

  def presenter_points
    points - suggestion_points
  end
end
