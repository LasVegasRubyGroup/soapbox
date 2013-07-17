class TopicDecorator < Draper::Decorator
  delegate_all

  def to_partial_path
    'topics/topic'
  end

  def link
    h.link_to title, h.topic_path(self)
  end

  def volunteer_data
    model.volunteers.by_name.map { |v| { id: v.user_id, name: v.name } }.to_json
  end

  def description
    h.markdown.render(model.description).html_safe
  end

  def user_name
    user.name
  end

  def volunteer_names
    model.volunteers.collect(&:user).collect(&:name)
  end
end
