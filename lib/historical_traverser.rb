class HistoricalTraverser
  REGEXP = /:(\d+)$/
  attr_reader :current, :relative, :timestamp

  def initialize name
    home = File.expand_path '~'
    Pathname.new("#{home}/.dir_sync").mkpath
    @path_old = "#{home}/.dir_sync/#{name}"
    @path_new = "#{@path_old}.new"
    @new = File.open @path_new, 'w'
    if File.exist? @path_old
      @traverser = Fiber.new do
        File.open(@path_old) do |file|
          file.each {|line| Fiber.yield line.chomp}
        end
        Fiber.yield nil
      end
      @current = :nothing
      advance
    end
  end

  def base
    "<history>"
  end

  def description
    @current
  end

  def advance
    @current = @traverser.resume if @current
    if @current
      match = REGEXP.match(@current)
      raise "unable to parse line \"#{@current}\"" unless match
      @relative = match.pre_match
      @timestamp = match[1].to_i
    end
  end
  alias next advance

  def close
    @new.close
    `mv #{@path_new} #{@path_old}`
  end

  def report traverser
    @new.puts traverser.description
  end

  def name
    @relative
  end

  def ts
    @timestamp
  end

  def empty?
    @current.nil?
  end

  def to_s
    @current
  end
end