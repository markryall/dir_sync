$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  let(:history) { stub 'history' }
  let(:traversers) { [] }
  let(:resolver) { SuperChangeResolver.new history, *traversers }

  def stub_traversers hashes
    hashes.each_with_index do |traverser_stubs, index|
      stubs = { ts: 0 }.merge traverser_stubs
      traversers << stub("traverser#{index}").tap do |traverser|
        stubs.each do |meth,ret|
           traverser.stub!(meth).and_return ret
        end
      end
    end
  end

  it 'should copy all other traversers to candidate' do
    stub_traversers [
      { name: 'a'},
      { name: 'b'},
      { name: 'c'},
    ]
    traversers[0].should_receive(:cp).with traversers[1], traversers[2]
    resolver.iterate
  end

  describe '#candidate' do
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

    it 'should determine the next candidate for the same name by most recent timestamp' do
      stub_traversers [
        { name: 'a', ts: 10},
        { name: 'a', ts: 20},
        { name: 'b'},
      ]
      resolver.candidate.should == traversers[1]
    end

    it 'should determine the next candidate for the same name by most recent timestamp' do
      stub_traversers [
        { name: 'a', ts: 20},
        { name: 'a', ts: 10},
        { name: 'b'},
      ]
      resolver.candidate.should == traversers[0]
    end
  end
end
