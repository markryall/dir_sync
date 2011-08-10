$: << File.dirname(__FILE__)+'/../lib'

require 'change_resolver'

describe ChangeResolver do
  before do
    @left = stub('left')
    @right = stub('right')
    @history = stub('history')
    @resolver = ChangeResolver.new @left, @right, @history
  end

  def stub_traverser stub, member, value
    if value
      stub.stub!(member).and_return(value)
      stub.stub!(:empty?).and_return(false)
    else
      stub.stub!(:empty?).and_return(true)
    end
  end

  def stub_all member, params
    stub_traverser @left, member, params[:left]
    stub_traverser @right, member, params[:right]
    stub_traverser @history, member, params[:history]
  end

  def relative params
    stub_all :relative, params
  end

  def timestamp params
    stub_all :timestamp, params
  end

  it 'should resolve finished with nothing' do
    relative :left => nil, :right => nil
    @resolver.dispatch.should == :finished
  end

  it 'should resolve right_added with right only' do
    relative :right => 'a'
    @resolver.dispatch.should == :right_added
  end

  it 'should resolve left_added with left only' do
    relative :left => 'b'
    @resolver.dispatch.should == :left_added
  end

  describe 'left and right are equal' do
    it 'should resolve equal when name and timestamps are equal' do
      relative  :left => 'a', :right => 'a'
      timestamp :left => 100, :right => 100
      @resolver.dispatch.should == :both_equal
    end

    it 'should resolve left_modified when names are equal and left is more recent' do
      relative  :left => 'a', :right => 'a'
      timestamp :left => 200, :right => 100
      @resolver.dispatch.should == :left_modified
    end

    it 'should resolve right_modified when names are equal and right is more recent' do
      relative  :left => 'a', :right => 'a'
      timestamp :left => 100, :right => 200
      @resolver.dispatch.should == :right_modified
    end
  end

  describe 'without history' do
    it 'should resolve left added' do
      relative :left => 'abc', :right => 'def'
      @resolver.dispatch.should == :left_added
    end

    it 'should resolve right added' do
      relative :left => 'def', :right => 'abc'
      @resolver.dispatch.should == :right_added
    end
  end

  describe 'with history' do
    it 'should resolve left deleted' do
      relative :left => 'def', :right => 'abc', :history => 'abc'
      @resolver.dispatch.should == :left_deleted
    end

    it 'should resolve right deleted' do
      relative :left => 'abc', :right => 'def', :history => 'abc'
      @resolver.dispatch.should == :right_deleted
    end

    it 'should resolve left added' do
      relative :left => 'abc', :right => 'def', :history => 'def'
      @resolver.dispatch.should == :left_added
    end

    it 'should resolve right added' do
      relative :left => 'def', :right => 'abc', :history => 'def'
      @resolver.dispatch.should == :right_added
    end
  end
end