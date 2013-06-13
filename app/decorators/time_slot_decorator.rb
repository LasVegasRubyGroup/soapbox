class TimeSlotDecorator < Draper::Decorator
  delegate_all

  def time
    starts_at
  end
end
