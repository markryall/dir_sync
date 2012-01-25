class SuperChangeResolver
  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def iterate
    first, *rest = candidates
    first.cp *rest
  end

  def candidate
    candidates.first
  end

  def candidates
    @traversers.sort do |left,right|
      combine left.name <=> right.name, right.ts <=> left.ts
    end
  end

  def combine *exps
    exps.each { |exp| return exp unless exp == 0 }
    0
  end
end