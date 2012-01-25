$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  let(:history) { stub 'history', :name => nil }
  let(:traversers) { [] }
  let(:resolver) { SuperChangeResolver.new history, *traversers }

  def stub_history hash
    hash.each do |meth,ret|
       history.stub!(meth).and_return ret
    end
  end

  def stub_traversers hashes
    hashes.each_with_index do |traverser_stubs, index|
      stubs = { ts: 0 }.merge traverser_stubs
      traversers << stub("traverser#{index}").tap do |traverser|
        traverser.stub! :cp
        traverser.stub! :advance
        traverser.stub! :ignored?
        stubs.each do |meth,ret|
           traverser.stub!(meth).and_return ret
        end
      end
    end
  end

  def candidate
    resolver.candidates.first
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

  it 'should remove files that are ignored' do
    stub_traversers [
      { name: 'a', ignored?: true},
      { name: 'b'},
      { name: 'c'},
    ]
    traversers[0].should_receive :rm
    resolver.iterate
  end

  it 'should advance history when it has candidate name' do
    stub_history name: 'a'
    stub_traversers [{ name: 'a'}, { name: 'b'}]
    history.should_receive :advance
    resolver.iterate
  end

  it 'should advance traversers with the candidate name' do
    stub_history name: 'b'
    stub_traversers [
      { name: 'a'},
      { name: 'a'},
      { name: 'b'},
    ]
    history.should_not_receive :advance
    traversers[0].should_receive :advance
    traversers[1].should_receive :advance
    traversers[2].should_not_receive :advance
    resolver.iterate
  end

  describe '#candidate' do
    it 'should determine the next candidate according to the name collation order' do
      stub_traversers [
        { name: 'a'},
        { name: 'b'},
        { name: 'c'},
      ]
      candidate.should == traversers[0]
    end

    it 'should determine the next candidate according to the name collation order' do
      stub_traversers [
        { name: 'c'},
        { name: 'b'},
        { name: 'a'},
      ]
      candidate.should == traversers[2]
    end

    it 'should determine the next candidate for the same name by most recent timestamp' do
      stub_traversers [
        { name: 'a', ts: 10},
        { name: 'a', ts: 20},
        { name: 'b'},
      ]
      candidate.should == traversers[1]
    end

    it 'should determine the next candidate for the same name by most recent timestamp' do
      stub_traversers [
        { name: 'a', ts: 20},
        { name: 'a', ts: 10},
        { name: 'b'},
      ]
      candidate.should == traversers[0]
    end
  end
end
