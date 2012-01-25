$: << File.dirname(__FILE__)+'/../lib'

require 'synchroniser'

describe Synchroniser do
  it 'should call iterate once resolved if it returns false' do
    resolver = stub 'resolver'
    synchroniser = Synchroniser.new resolver
    resolver.should_receive(:iterate).and_return false
    synchroniser.iterate
  end

  it 'should repeatedly call iterate on resolved until it returns false' do
    resolver = stub 'resolver'
    synchroniser = Synchroniser.new resolver
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return true
    resolver.should_receive(:iterate).and_return false
    synchroniser.iterate
  end
end