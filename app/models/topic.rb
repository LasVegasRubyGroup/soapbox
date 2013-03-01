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

    after_transition on: :close do |topic, transition|
      # give_points
    end

    event :selected do
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

  def votes
    voters.count
  end
end
