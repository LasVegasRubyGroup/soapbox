module MeetingsHelper

  def kudos_chart_data
    @meeting.time_slots.map do |time_slot|
      {
        presenter: time_slot.presenter.name,
        kudos: time_slot.topic.kudos.count
      }
    end
  end

end