$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  let(:history) { stub 'history' }
  let(:traversers) { [] }
  let(:resolver) { SuperChangeResolver.new history, *traversers }

  def stub_traversers hashes
    hashes.each_with_index do |traverser_stubs, index|
      traverser_stubs.each do |meth,ret|
        traversers << stub("traverser#{index}").tap {|t| t.stub!(meth).and_return ret }
      end
    end
  end

  it 'should determine the next candidate according to the name collation order' do
    stub_traversers [
      { name: 'a'},
      { name: 'b'},
      { name: 'c'},
    ]
    resolver.candidate.should == traversers[0]
  end

  it 'should determine the next candidate according to the name collation order' do
    stub_traversers [
      { name: 'c'},
      { name: 'b'},
      { name: 'a'},
    ]
    resolver.candidate.should == traversers[2]
  end

  it 'should determine the next candidate for the same name by earliest timestamp'
  it 'should determine the next candidate for the same name and timestamp favouring non historical'
end