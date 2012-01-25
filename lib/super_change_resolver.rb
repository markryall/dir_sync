class SuperChangeResolver
  def debug message
    puts "# #{message}" if ENV['DEBUG']
  end

  def initialize history, *traversers
    @history, @traversers = history, traversers
  end

  def iterate
    report_traversers
    first = candidates.first
    return false unless first
    debug "first is #{first.description}"
    first.ignored? ? rm(first) : cp(first)
    advance_matching_traversers first.name, @history, *@traversers
  end

  def candidate
    candidates.first
  end
private
  def rm traverser
    traverser.rm
  end

  def cp traverser
    @history.report traverser
    traverser.cp *@traversers
  end

  def report_traversers
    report @history
    @traversers.each { |traverser| report traverser }
  end

  def report traverser
    debug "#{traverser.base}: #{traverser.description}"
  end

  def advance_matching_traversers name, *traversers
    traversers.each do |traverser|
      debug "#{traverser.base}: comparing #{name} and #{traverser.name}"
      traverser.advance if traverser.name == name
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