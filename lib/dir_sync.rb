require 'dir_sync/change_log_file_system'
require 'dir_sync/traverser'
require 'historical_traverser'
require 'change_resolver'

module DirSync
  def self.sync name, *paths
    if paths.count < 2
      puts "usage: #{__FILE__} name directory1 directory2 ..."
      puts " set DEBUG for verbose output"
      exit 1
    end
    file_system = DirSync::ChangeLogFileSystem.new $stdout
    traversers = paths.map {|path| DirSync::Traverser.new path, file_system }
    history = HistoricalTraverser.new name
    resolver = ChangeResolver.new history, *traversers
    loop { break unless resolver.iterate }
    history.close
  end
end
