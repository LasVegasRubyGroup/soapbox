class PointsManager
  def initialize topics
    @topics = topics
  end

  def award
    [ { @topics[0].presenter.name => PointsRecord.new } ]
  end
end
