require 'traverser'
require 'historical_traverser'
require 'change_resolver'
require 'change_log_file_system'

module Synchroniser
  def self.iterate name, *paths
    file_system = ChangeLogFileSystem.new $stdout
    traversers = paths.map {|path| Traverser.new path, file_system }
    history = HistoricalTraverser.new name
    resolver = ChangeResolver.new history, *traversers
    loop { break unless resolver.iterate }
    history.close
  end
end