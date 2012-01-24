$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  it 'should create a resolver' do
    @history, @traverser1, @traverser2, @traverser3 = stub('history'), stub('traverser1'), stub('traverser2'), stub('traverser3')
    resolver = SuperChangeResolver.new @history, @traverser1, @traverser2, @traverser3
  end

  it 'should determine the next candidate according to the name collation order'
  it 'should determine the next candidate for the same name by earliest timestamp'
  it 'should determine the next candidate for the same name and timestamp favouring non historical'
end