module DirSync
end

class DirSync::HistoryTraverser
  attr_reader :name, :ts, :base, :description
  REGEXP = /:(\d+)$/

  def initialize name
    home = File.expand_path '~'
    Pathname.new("#{home}/.dir_sync").mkpath
    @path_old = "#{home}/.dir_sync/#{name}"
    @path_new = "#{@path_old}.new"
    @new = File.open @path_new, 'w'
    @base = '<history>'
    if File.exist? @path_old
      @fiber = Fiber.new do
        File.open(@path_old) do |file|
          file.each {|line| Fiber.yield line.chomp}
        end
        Fiber.yield nil
      end
      @description = :nothing
      advance
    end
  end

  def advance
    @description = @fiber.resume if @description
    if @description
      match = REGEXP.match @description
      raise "unable to parse line \"#{@description}\"" unless match
      @name = match.pre_match
      @ts = match[1].to_i
    end
  end

  def close
    @new.close
    `mv #{@path_new} #{@path_old}`
  end

  def report traverser
    @new.puts traverser.description
  end

  def empty?
    @description.nil?
  end
end
