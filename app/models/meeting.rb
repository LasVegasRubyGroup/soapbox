class Meeting < ActiveRecord::Base
  has_many :topics
  has_many :time_slots

  after_save :update_topics

  attr_accessible :date, :status, :time_slots_attributes

  accepts_nested_attributes_for :time_slots

  state_machine initial: :open do
    state :open
    state :closed

    after_transition on: :finalize do |meeting, transition|
      mark_topics_closed!
      give_points!
    end

    event :finalize do
      transition to: :closed, from: [:open]
    end
  end

  def self.by_date
    order('date DESC')
  end

  def self.prototype
    self.new(
      date: Date.today + 2.weeks,
      time_slots_attributes: [
        { starts_at: '6:20 PM', ends_at: '6:50 PM' },
        { starts_at: '6:50 PM', ends_at: '7:20 PM' },
        { starts_at: '7:20 PM', ends_at: '7:50 PM' }
      ]
    )
  end

private

  def update_topics
    topics.each do |topic|
      topic.update_attribute(:meeting_id, id)
    end
  end

  def mark_topics_closed
    topics.each do |topic|
      topic.close!
    end
  end

  def give_points
    time_slots.map do |time_slot|
      time_slot.give_points
    end
  end
end
