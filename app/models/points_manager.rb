class PointsManager
  attr_reader :topics, :calculator
  def initialize(topics, calculator)
    @topics = topics
    @calculator = calculator
  end

  def award
    #calc
    #assign
    calculator.calculate(topics.first)
  end

private
  def calculate_award
  end
  def assign_award
  end

end
