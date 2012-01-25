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
    advance_matching_traversers first.name, @history, *non_empty_traversers
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
    traversers.select{|t| t.name == name}.each &:advance
  end

  def non_empty_traversers
    @traversers.select {|t| !t.empty? }
  end

  def candidates
    non_empty_traversers.sort do |left,right|
      combine left.name <=> right.name, right.ts <=> left.ts
    end
  end

  def combine *exps
    exps.each { |exp| return exp unless exp == 0 }
    0
  end
end