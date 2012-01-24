$: << File.dirname(__FILE__)+'/../lib'

require 'super_change_resolver'

describe SuperChangeResolver do
  it 'should create a resolver' do
    @history, @traverser1, @traverser2, @traverser3 = stub('history'), stub('traverser1'), stub('traverser2'), stub('traverser3')
    resolver = SuperChangeResolver.new @history, @traverser1, @traverser2, @traverser3
  end
end