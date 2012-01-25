class ChangeLogFileSystem
  def initialize io
    @io = io
  end

  def cp from, to
    @io.puts "cp -p #{from} #{to}"
  end

  def rm path
    @io.puts "rm #{path}"
  end
end