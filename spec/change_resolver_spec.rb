$: << File.dirname(__FILE__)+'/../lib'

require 'change_resolver'

describe ChangeResolver do
  let(:history) { stub 'history', name: nil, base: nil, description: nil, report: nil, advance: nil }
  let(:traversers) { [] }
  let(:resolver) { ChangeResolver.new history, *traversers }

  def stub_history hash
    hash.each do |meth,ret|
       history.stub!(meth).and_return ret
    end
  end

  def stub_traversers hashes
    hashes.each_with_index do |traverser_stubs, index|
      stubs = {
        ts: 0,
        cp: nil,
        advance: nil,
        empty?: false,
        ignored?: false,
        base: nil,
        description: nil,
        equivalent?: false
      }.merge traverser_stubs
      traversers << stub("traverser#{index}").tap do |traverser|
        stubs.each do |meth,ret|
           traverser.stub!(meth).and_return ret
        end
      end
    end
  end

  def candidate
    resolver.candidate
  end

  describe '#iterate' do
    it 'should return true if any traverser is not empty' do
      stub_traversers [
        { name: 'a'},
        { name: 'a'}
      ]
      resolver.iterate.should be_true
    end

    it 'should return false if all traversers are empty' do
      stub_traversers [
        { name: 'a'},
        { name: 'b'}
      ]
      traversers[0].should_receive(:empty?).and_return true
      traversers[1].should_receive(:empty?).and_return true
      resolver.iterate.should be_false
    end

    it 'should copy all other traversers to candidate' do
      stub_traversers [
        { name: 'a'},
        { name: 'b'},
        { name: 'c'},
      ]
      traversers[0].should_receive(:cp).with *traversers
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

    it 'should ignore files that appear in history and have not been removed from any traverser' do
      stub_history name: 'a'
      stub_traversers [
        { name: 'a'},
        { name: 'a'}
      ]
      traversers[0].should_receive(:equivalent?).with(history).and_return true
      traversers[0].should_receive(:equivalent?).with(traversers[0]).and_return true
      traversers[0].should_receive(:equivalent?).with(traversers[1]).and_return true
      traversers[0].should_not_receive :rm
      resolver.iterate
    end

    it 'should remove files that appear in history but have been removed from a traverser' do
      stub_history name: 'a'
      stub_traversers [
        { name: 'a'},
        { name: 'b'},
        { name: 'a'}
      ]
      traversers[0].should_receive(:equivalent?).with(history).and_return true
      traversers[0].should_receive(:equivalent?).with(traversers[0]).and_return true
      traversers[0].should_receive(:equivalent?).with(traversers[1]).and_return false
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
