require 'traverser'
require 'historical_traverser'
require 'change_resolver'

module Synchroniser
  def self.iterate name, *paths
    traversers = paths.map {|path| Traverser.new path }
    history = HistoricalTraverser.new name
    resolver = ChangeResolver.new history, *traversers
    loop { break unless resolver.iterate }
    history.close
  end
end