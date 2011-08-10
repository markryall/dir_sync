class HistoricalTraverser
  REGEXP = /:(\d+)$/
  attr_reader :current, :relative, :timestamp

  def initialize path
    if File.exist? path
      @traverser = Fiber.new do
        File.open(path) do |file|
          file.each {|line| Fiber.yield line.chomp}
        end
        Fiber.yield nil
      end
      @current = :first
    end
  end

  def next
    @current = @traverser.resume if @current
    if @current
      match = REGEXP.match(@current)
      raise "unable to parse line \"#{@current}\"" unless match
      @relative = match.pre_match
      @timestamp = match[1].to_i
    end
  end

  def empty?
    @current.nil?
  end

  def to_s
    @current
  end
end