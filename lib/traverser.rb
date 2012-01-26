require 'pathname'

class Traverser
  attr_reader :base

  TOLERANCE=5
  IGNORE_PATTERNS = [
    /\.DS_Store$/,
    /\._/
  ]

  def initialize path, file_system
    @file_system = file_system
    @base = Pathname.new path
    @base.mkpath
    @fiber = Fiber.new do
      @base.find { |child| Fiber.yield child if child.file? }
      Fiber.yield nil
    end
    @current = @fiber.resume
  end

  def description
    empty? ? 'empty' : "#{name}:#{ts}"
  end

  def advance
    @current = @fiber.resume if @current
  end

  def name
    @current.relative_path_from(@base).to_s if @current
  end

  def ts
    @current.mtime.to_i if @current
  end

  def empty?
    @current.nil?
  end

  def ignored?
    IGNORE_PATTERNS.any? {|pattern| pattern.match name }
  end

  def cp *traversers
    traversers.each do |t|
      @file_system.cp @current.to_s, "#{t.base}/#{name}" unless equivalent? t
    end
  end

  private

  def equivalent? traverser
    name == traverser.name and (ts - traverser.ts).abs <= TOLERANCE
  end
end