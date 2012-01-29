$: << File.dirname(__FILE__)+'/../lib'

require 'dir_sync/traverser'

describe DirSync::Traverser do
  let(:pathname) { stub 'pathname', mkpath: nil, find: nil}
  let(:file_system) { stub 'file_system'}
  let(:traverser) { DirSync::Traverser.new 'a', file_system }

  before do
    Pathname.should_receive(:new).with('a').and_return pathname
  end

  it 'should create path' do
    pathname.should_receive :mkpath
    traverser
  end

  def with_file name, mtime=0
    child_pathname = stub 'current_pathname', file?: true, mtime: mtime, to_s: "a/#{name}"
    child_pathname.stub!(:relative_path_from).with(pathname).and_return name
    pathname.stub!(:find).and_yield child_pathname
  end

  it 'should skip copying to itself' do
    with_file '1.txt'
    file_system.should_not_receive :cp
    traverser.cp traverser
  end

  it 'should copy to traversers with a different file name' do
    with_file '1.txt'
    other_traverser = stub 'other_traverser', base: 'b', name: '2.txt'
    file_system.should_receive(:cp).with 'a/1.txt', 'b/1.txt'
    traverser.cp other_traverser
  end

  it 'should skip copying to traversers with the same file name and timestamp' do
    with_file '1.txt', 10
    other_traverser = stub 'other_traverser', base: 'b', name: '1.txt', ts: 10
    file_system.should_not_receive :cp
    traverser.cp other_traverser
  end

  it 'should skip copying to traversers with the same file name and timestamp is within tolerance' do
    with_file '1.txt', 10
    other_traverser = stub 'other_traverser', base: 'b', name: '1.txt', ts: 15
    file_system.should_not_receive :cp
    traverser.cp other_traverser
  end

  it 'should skip copying to traversers with the same file name and timestamp is outside tolerance' do
    with_file '1.txt', 10
    other_traverser = stub 'other_traverser', base: 'b', name: '1.txt', ts: 16
    file_system.should_receive(:cp).with 'a/1.txt', 'b/1.txt'
    traverser.cp other_traverser
  end
end
