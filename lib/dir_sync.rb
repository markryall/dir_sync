require 'dir_sync/change_log_file_system'
require 'dir_sync/traverser'
require 'dir_sync/history_traverser'
require 'dir_sync/change_resolver'

module DirSync
  def self.sync name, *paths
    if paths.count < 2
      puts "usage: #{__FILE__} name directory1 directory2 ..."
      puts " set DEBUG for verbose output"
      exit 1
    end
    file_system = DirSync::ChangeLogFileSystem.new $stdout
    traversers = paths.map {|path| DirSync::Traverser.new path, file_system }
    history = DirSync::HistoryTraverser.new name
    resolver = DirSync::ChangeResolver.new history, *traversers
    loop { break unless resolver.iterate }
    history.close
  end

  def self.drain *paths
    if paths.empty?
      puts "usage: #{__FILE__} *scripts"
      puts "  Runs a set of single line commands one by one (so that you can interrupt and the script will resume)"
      exit 1
    end

    paths.each do |path|
      lines = File.readlines(path).map {|s| s.chomp.strip }.select {|s| !s.empty? and !s.start_with?('#')}

      loop do
        break if lines.empty?
        lines.shift.tap {|s| puts "> #{s}" }.tap {|s| puts `#{s}` }
        File.open("#{path}.tmp", 'w') {|f| f.puts lines.join "\n" }
        `mv #{path}.tmp #{path}`
      end
      `rm #{path}`
    end
  end
end
