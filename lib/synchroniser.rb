class Synchroniser
  def initialize resolver
    @resolver = resolver
  end

  def iterate
    loop do
      return unless @resolver.iterate
    end
  end
end