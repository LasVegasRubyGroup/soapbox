class TopicDecorator < Draper::Base
  decorates :topic

  def to_partial_path
    'topics/topic'
  end

  def link
    h.link_to topic.title, h.topic_path(topic)
  end

  def volunteer_data
    topic.volunteers.map { |v| { id: v.user_id, name: v.name } }.to_json
  end

  def description
    h.markdown.render(topic.description).html_safe
  end

  def user_name
    'TODO'
  end

  def volunteer_names
    ['TODO']
  end
end
