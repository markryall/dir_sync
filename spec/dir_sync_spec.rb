$: << File.dirname(__FILE__)+'/../lib'

require 'dir_sync'

describe DirSync do
  let(:file_system) { stub 'file_system' }
  let(:resolver) { stub 'resolver'}
  let(:history) { stub 'history', close: nil }
  let(:traverser_a) { stub 'traverser_a' }
  let(:traverser_b) { stub 'traverser_b' }

  before do
    DirSync::ChangeLogFileSystem.should_receive(:new).with($stdout).and_return file_system
    DirSync::HistoryTraverser.should_receive(:new).with('test').and_return history
    DirSync::Traverser.should_receive(:new).with('a', file_system).and_return traverser_a
    DirSync::Traverser.should_receive(:new).with('b', file_system).and_return traverser_b
    DirSync::ChangeResolver.should_receive(:new).with(history, traverser_a, traverser_b).and_return resolver
  end

  it 'should call iterate once resolved if it returns false' do
    resolver.should_receive(:iterate).and_return false
    DirSync.sync 'test', 'a', 'b'
  end

  it 'should repeatedly call iterate on resolved until it returns false' do
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return false
    DirSync.sync 'test', 'a', 'b'
  end
end
