class ChangeLogFileSystem
  def initialize io
    @io = io
  end

  def cp from, to
    to_dir = File.dirname to
    @io.puts "mkdir -p \"#{to_dir}\"" unless File.exist? to_dir
    @io.puts "cp -p \"#{from}\" \"#{to}\""
  end

  def rm path
    @io.puts "rm \"#{path}\""
  end
end