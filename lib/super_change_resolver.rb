class SuperChangeResolver
  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def candidate
    @traversers.each {|traverser| traverser.name }
    @traversers[2]
  end
end