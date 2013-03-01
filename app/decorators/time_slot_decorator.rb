class TimeSlotDecorator < Draper::Base
  decorates :time_slot

  def time
    time_slot.starts_at
  end
end
