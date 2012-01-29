$: << File.dirname(__FILE__)+'/../lib'

require 'dir_sync/history_traverser'

describe DirSync::HistoryTraverser do
  let(:dir_sync_path) { stub 'dir_sync_path', mkpath: nil }
  let(:new_path) { stub 'new_path' }
  let(:traverser) { DirSync::HistoryTraverser.new 'test' }

  before do
    File.stub!(:expand_path).with('~').and_return '/home/user'
    Pathname.stub!(:new).with('/home/user/.dir_sync').and_return dir_sync_path
    File.stub!(:open).with('/home/user/.dir_sync/test.new', 'w').and_return new_path
  end

  it 'should create the ~/.dir_sync directory' do
    dir_sync_path.should_receive :mkpath
    traverser
  end

  it 'should open the new file for capturing new state' do
    File.should_receive(:open).with '/home/user/.dir_sync/test.new', 'w'
    traverser
  end
end
