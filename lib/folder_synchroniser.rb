require 'traverser'
require 'historical_traverser'
require 'change_resolver'
require 'FileUtils'

class FolderSynchroniser
  IGNORE_PATTERNS = [
    /\.DS_Store$/
  ]

  def initialize left, right, previous
    @previous = previous || 'history'
    @left = Traverser.new Pathname.new(left)
    @right = Traverser.new Pathname.new(right)
    @old = HistoricalTraverser.new @previous
    @new = File.open(@previous+'.tmp', 'w')
    @resolver = ChangeResolver.new @left, @right, @old
  end

  def both_equal
    report left
    progress_all
  end

  def both_modified
    puts "# Both of the following have changed - please resolve manually:\n\t#{left.current}\n\t#{right.current}"
    report old
    progress_all
  end

  def left_deleted
    remove_right
    progress_right
    progress_old
  end

  def right_deleted
    remove_left
    progress_left
    progress_old
  end

  def left_modified
    copy_left_to_right
    report left
    progress_all
  end

  def right_modified
    copy_right_to_left
    report right
    progress_all
  end

  def left_added
    copy_left_to_right
    report left
    progress_left
  end

  def right_added
    copy_right_to_left
    report right
    progress_right
  end

  def execute
    progress_all
    loop do
      debug "Left:\n\t#{left}" unless left.empty?
      debug "Right:\n\t#{right}" unless right.empty?
      debug "History:\n\t#{old}" unless old.empty?
      send @resolver.dispatch.tap {|method| debug "State:\n\t#{method}"}
      step
      break if left.empty? and right.empty?
    end
    close
  end
private
  attr_reader :left, :right, :old

  def debug message
    puts message if ENV['DEBUG']
  end

  def step
    return unless ENV['DEBUG']
    print "----------------------------\nContinue ?"
    $stdin.gets
  end

  def report traverser
    @new.puts traverser
  end

  def close
    @new.close
    `mv #{@previous}.tmp #{@previous}`
  end

  def rm path
    puts "rm \"#{path}\""
  end

  def mkdir path
    puts "mkdir -p \"#{path}\""
  end

  def cp from, to
    puts "cp -p \"#{from}\" \"#{to}\""
  end

  def remove_right
    rm right.current
  end

  def remove_left
    rm left.current
  end

  def copy_right_to_left
    copy_from right, left
  end

  def copy_left_to_right
    copy_from left, right
  end

  def copy_from source, target
    source_path, destination_path = source.current.to_s, target.base.to_s+'/'+source.relative
    IGNORE_PATTERNS.each do |pattern|
      if pattern.match(source_path)
        rm source_path
        return
      end
    end
    destination_directory = File.dirname(destination_path)
    mkdir destination_directory unless File.exist? destination_directory
    cp source_path, destination_path
  end

  def run command
    debug command
    system command
  end

  def progress_left
    left.next
  end
  
  def progress_right
    right.next
  end

  def progress_old
    old.next
  end

  def progress_all
    progress_left
    progress_right
    progress_old
  end
end