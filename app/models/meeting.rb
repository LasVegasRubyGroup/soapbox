class Meeting < ActiveRecord::Base
  has_many :topics
  has_many :time_slots

  after_save :update_topics

  attr_accessible :date, :status, :time_slots_attributes, :state

  accepts_nested_attributes_for :time_slots

  state_machine initial: :open do
    state :open
    state :closed

    event :finalize do
      transition to: :closed, from: [:open]
    end
  end

  def self.by_date
    order('date DESC')
  end

  def self.prototype(on_date=(Date.today + 2.weeks))
    self.new(
      date: on_date,
      time_slots_attributes: [
        { starts_at: '6:20 PM', ends_at: '6:50 PM' },
        { starts_at: '6:50 PM', ends_at: '7:20 PM' },
        { starts_at: '7:20 PM', ends_at: '7:50 PM' }
      ]
    )
  end

  def mark_topics_selected
    topics.each do |topic|
      topic.mark_as_selected!(self)
    end
  end

  def update_topics
    topics.each do |topic|
      topic.update_attribute(:meeting_id, id)
    end
  end

  def mark_topics_closed!
    topics.each do |topic|
      topic.close!
    end
  end

  def give_points!
    time_slots.map do |time_slot|
      time_slot.give_points
    end
  end

  def finalize_and_reward!
    ActiveRecord::Base.transaction do
      finalize!
      mark_topics_closed!
      give_points!
    end
  end

  def kudos_available?(time)
    #todo need to break this up
    time.to_date == date.to_date &&
    ((time.hour == 19 && time.min >= 45) ||
      (time.hour > 19 && time.hour < 20)) &&
    state == 'open'
  end
end
