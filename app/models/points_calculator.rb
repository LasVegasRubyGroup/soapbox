class PointsCalculator
  BASE_PRESENTER_POINTS = 5
  def calculate(topic)
    return {} if topic.nil?

    if topic.user == topic.presenter
      {
        topic.presenter => all_points_for(topic)
      }
    else
      {
        topic.user => suggester_points_for(topic),
        topic.presenter => presenter_points_for(topic)
      }
    end
  end

  private

  def presenter_points_for(topic)
    (topic.votes - suggester_points_for(topic)) + BASE_PRESENTER_POINTS + topic.kudos_count
  end

  def suggester_points_for(topic)
    topic.votes / 4
  end

  def all_points_for(topic)
    topic.votes + topic.kudos_count + BASE_PRESENTER_POINTS
  end
end