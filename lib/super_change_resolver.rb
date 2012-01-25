class SuperChangeResolver
  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def candidate
    @traversers.sort do |left,right|
      combine left.name <=> right.name, right.ts <=> left.ts
    end.first
  end

  def combine *exps
    exps.each { |exp| return exp unless exp == 0 }
    0
  end
end