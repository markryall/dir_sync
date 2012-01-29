$: << File.dirname(__FILE__)+'/../lib'

require 'dir_sync/change_log_file_system'

describe DirSync::ChangeLogFileSystem do
  let(:io) { stub 'io' }
  let(:file_system) { DirSync::ChangeLogFileSystem.new io }

  it 'should cp a file' do
    io.should_receive(:puts).with 'cp -p "from" "to"'
    file_system.cp 'from', 'to'
  end

  it 'should mkdir for cp when parent does not exist' do
    io.should_receive(:puts).with 'mkdir -p "a/b/c"'
    io.should_receive(:puts).with 'cp -p "from" "a/b/c/to"'
    file_system.cp 'from', 'a/b/c/to'
  end

  it 'should rm a file' do
    io.should_receive(:puts).with 'rm "file"'
    file_system.rm 'file'
  end
end
