require 'traverser'
require 'historical_traverser'
require 'super_change_resolver'

module Synchroniser
  def self.iterate name, *paths
    traversers = paths.map {|path| Traverser.new path }
    history = HistoricalTraverser.new name
    resolver = SuperChangeResolver.new history, *traversers
    loop { break unless resolver.iterate }
    history.close
  end
end