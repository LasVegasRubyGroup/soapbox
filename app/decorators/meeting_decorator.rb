class MeetingDecorator < Draper::Decorator
  delegate_all
  decorates_association :time_slots

  def meeting_date
    date.to_date.to_s(:long)
  end

  def kudo_links_for(current_user)
    if kudos_available?(Time.current, current_user)
      h.render 'kudo_links'
    end
  end

  def points_awarded 
    h.render 'points_awarded' if closed?
  end

  def edit_link_for(current_user)
    current_user.edit_meeting_link(self)
  end

  def finalize_link_for(current_user)
    current_user.finalize_meeting_link(self)
  end
end
