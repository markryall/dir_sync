class ChangeResolver
  TOLERANCE = 5

  def initialize history, left, right
    @left, @right, @history = left, right, history
  end

  def dispatch
    return :finished if left.empty? and right.empty?

    unless history.empty?
      return :both_removed if left_ahead_of_history? and right_ahead_of_history?

      return :both_modified if left_equal_to_right? and left_equal_to_history? and left_newer_than_history? and right_newer_than_history?

      return :left_deleted if right_equal_to_history? and left.empty?
      return :right_deleted if left_equal_to_history? and right.empty?

      return :left_deleted if right_equal_to_history? and left_ahead_of_right?
      return :right_deleted if left_equal_to_history? and right_ahead_of_left?

      return :left_added if right_equal_to_history? and right_ahead_of_left?
      return :right_added if left_equal_to_history? and left_ahead_of_right?
    end

    return :left_added if right.empty?
    return :right_added if left.empty?

    return :left_added if right_ahead_of_left?
    return :right_added if left_ahead_of_right?

    return :left_modified if left_equal_to_right? and left_newer_than_right?
    return :right_modified if left_equal_to_right? and right_newer_than_left?
    return :all_equal if left_equal_to_right? and !history.empty? and left_equal_to_history?
    return :both_equal if left_equal_to_right?

    raise 'not sure how to handle this situation'
  end
private
  attr_reader :left, :right, :history

  def left_newer_than_history?
    left.timestamp - history.timestamp > TOLERANCE
  end

  def right_newer_than_history?
    right.timestamp - history.timestamp > TOLERANCE
  end

  def left_newer_than_right?
    left.timestamp - right.timestamp > TOLERANCE
  end

  def right_newer_than_left?
    right.timestamp - left.timestamp > TOLERANCE
  end

  def left_equal_to_right?
    left.relative == right.relative
  end

  def left_ahead_of_history?
    left.relative > history.relative
  end

  def right_ahead_of_history?
    right.relative > history.relative
  end

  def left_ahead_of_right?
    left.relative > right.relative
  end

  def right_ahead_of_left?
    left.relative < right.relative
  end

  def left_equal_to_history?
    history.relative == left.relative
  end

  def right_equal_to_history?
    history.relative == right.relative
  end
end