class UserDecorator < Draper::Decorator
  delegate_all

  def signed_in?
    !new_record?
  end

  def session_control
    if signed_in?
      h.link_to "Sign Out", h.sign_out_path, method: :delete
    else
      h.link_to('Sign In', h.omniauth_authorize_path('user', 'meetup'))
    end
  end

  def new_topic_link
    if signed_in?
      h.link_to "Suggest a presentation topic <i class='icon-comment icon-white'></i>".html_safe, h.new_topic_path, class: 'btn btn-primary btn-large'
    end
  end

  def new_meeting_link
    if organizer
      h.link_to('Create Meeting', h.new_meeting_path)
    end
  end

  def edit_meeting_link(meeting)
    if organizer && meeting.open?
      h.link_to('Edit Meeting', h.edit_meeting_path(meeting), class: 'btn')
    end
  end

  def finalize_meeting_link(meeting)
    if organizer && (meeting.open? || meeting.kudos_open?)
      h.link_to('Finalize', h.finalize_meeting_path(meeting), class: 'btn btn-success', method: :put)
    end
  end

  def edit_topic_link(topic)
    if (topic.user == self) or organizer
      h.link_to 'Edit', h.edit_topic_path(topic), class: 'btn'
    end
  end

  def destroy_topic_link(topic)
    if organizer
      h.link_to 'Destroy', topic, :confirm => 'Are you sure?', :method => :delete, class: 'btn btn-danger btn-mini'
    end
  end

  def vote_link(topic)
    if signed_in? 
      if !voted_on?(topic)
        #todo need a better way to do these <i> tag
        h.link_to "<i class='icon-thumbs-up'></i>Vote".html_safe, h.vote_topic_path(topic), method: :put, remote: true, class: 'btn'
      else
        h.content_tag :span, "<i class='icon-ok icon-white'></i> Voted".html_safe, class: 'btn btn-success'
      end
    end
  end

  def volunteer_link(topic)
    if signed_in?
      if !volunteered_for?(topic)
        h.link_to "<i class='icon-star'></i> Volunteer".html_safe, h.volunteer_topic_path(topic), method: :put, remote: true, class: 'btn btn-warning', confirm: "Are you sure you want to be a hero?"
      else
        h.content_tag :span, "<i class='icon-ok icon-white'></i>Volunteered".html_safe, class: 'label label-success'
      end
    end
  end
end
