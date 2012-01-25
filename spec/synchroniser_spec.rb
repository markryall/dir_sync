$: << File.dirname(__FILE__)+'/../lib'

require 'synchroniser'

describe Synchroniser do
  let(:resolver) { stub 'resolver'}
  let(:history) { stub 'history', close: nil }
  let(:traverser_a) { stub 'traverser_a' }
  let(:traverser_b) { stub 'traverser_b' }

  before do
    HistoricalTraverser.should_receive(:new).with('test').and_return history
    Traverser.should_receive(:new).with('a').and_return traverser_a
    Traverser.should_receive(:new).with('b').and_return traverser_b
    SuperChangeResolver.should_receive(:new).with(history, traverser_a, traverser_b).and_return resolver
  end

  it 'should call iterate once resolved if it returns false' do
    resolver.should_receive(:iterate).and_return false
    Synchroniser.iterate 'test', 'a', 'b'
  end

  it 'should repeatedly call iterate on resolved until it returns false' do
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return false
    Synchroniser.iterate 'test', 'a', 'b'
  end
end