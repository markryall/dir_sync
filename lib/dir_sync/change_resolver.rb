module DirSync
end

class DirSync::ChangeResolver
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
    send dispatch(first), first
    advance_matching_traversers first.name, @history, *non_empty_traversers
  end

  def candidate
    candidates.first
  end
private
  def dispatch traverser
    return :rm if traverser.ignored?
    if traverser.equivalent? @history
      return all_equivalent_traversers?(traverser) ? :ignore : :rm
    end
    :cp
  end

  def rm traverser
    @traversers.select{|t| t.name == traverser.name}.each &:rm
  end

  def cp traverser
    @history.report traverser
    traverser.cp *@traversers
  end

  def ignore traverser
    @history.report traverser
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

  def all_equivalent_traversers? traverser
    @traversers.all? {|t| traverser.equivalent? t }
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
