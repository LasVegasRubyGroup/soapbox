class Meeting < ActiveRecord::Base
  has_many :topics
  has_many :time_slots

  after_save :update_topics

  attr_accessible :date, :status, :time_slots_attributes, :state

  accepts_nested_attributes_for :time_slots

  state_machine initial: :open do
    event :open_kudos do
      transition :open => :kudos_open
    end

    event :finalize do
      transition [:open, :kudos_open] => :closed
    end
  end

  def self.by_date
    order('date DESC')
  end

  def self.prototype(on_date = (Date.today + 2.weeks))
    self.new(
      date: on_date,
      time_slots_attributes: [
        { starts_at: '6:20 PM', ends_at: '6:50 PM' },
        { starts_at: '6:50 PM', ends_at: '7:20 PM' },
        { starts_at: '7:20 PM', ends_at: '7:50 PM' }
      ]
    )
  end

  def self.prototype_with_time_slots(time_slots, on_date = (Date.today + 2.weeks))
    self.new(
      date: on_date,
      time_slots_attributes: time_slots)
  end

  def update_topics
    topics.each do |topic|
      topic.update_attribute(:meeting_id, id)
    end
  end

  def open_kudos!
    self.open_kudos
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

  def award_kudo_points
    time_slots.each do |time_slot| 
      points = time_slot.topic.kudos.count
      time_slot.presenter.points += points
    end
  end

  def finalize_and_reward!
    ActiveRecord::Base.transaction do
      finalize!
      mark_topics_closed!
      give_points!
    end
  end

  def kudos_available?(user)
    kudos_open? && !given_kudo?(user)
  end

  def give_kudo(topic, user)
    Kudo.create!(topic: topic, user: user)
  end

  def given_kudo?(user)
    topics.any?{ |t| t.given_kudo?(user) }
  end
end
