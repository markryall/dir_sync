$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  let(:history) { stub 'history' }
  let(:traverser1) { stub 'traverser1' }
  let(:traverser2) { stub 'traverser2' }
  let(:traverser3) { stub 'traverser3' }
  let(:resolver) { SuperChangeResolver.new history, traverser1, traverser2, traverser3 }

  it 'should determine the next candidate according to the name collation order' do
    traverser1.should_receive(:name).and_return 'c'
    traverser2.should_receive(:name).and_return 'b'
    traverser3.should_receive(:name).and_return 'a'
    resolver.candidate.should == traverser3
  end

  it 'should determine the next candidate for the same name by earliest timestamp'
  it 'should determine the next candidate for the same name and timestamp favouring non historical'
end