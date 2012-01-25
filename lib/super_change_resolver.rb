class SuperChangeResolver
  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def candidate
    @traversers.sort do |left,right|
      left.name <=> right.name
    end.first
  end
end