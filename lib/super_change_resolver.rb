class SuperChangeResolver
  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def iterate
    first, *rest = candidates
    return false unless first
    first.ignored? ? first.rm : first.cp(*rest)
    advance_matching_traversers first, @history, *@traversers
  end

  def advance_matching_traversers first, *traversers
    traversers.each do |traverser|
      traverser.advance if traverser.name == first.name
    end
  end

  def candidates
    @traversers.select{|t| !t.empty? }.sort do |left,right|
      combine left.name <=> right.name, right.ts <=> left.ts
    end
  end

  def combine *exps
    exps.each { |exp| return exp unless exp == 0 }
    0
  end
end