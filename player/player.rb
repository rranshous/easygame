# player will be told when rounds start
# player will output the vector it would like to move it
# can move one cell in any direction, including diagnal

# STDIN will receive from game engine
# game_start -- game has started
# round_start -- round has started
# win -- game has ended, you won
# loss -- game has ended, you lost

# we push to stdout
# m x y -- move, x and y in the range of -1 to 1
# than end our moves with: end_turn


class Player

  def initialize move_chances, in_pipe, out_pipe
    @move_chances = move_chances.map(&:to_i)
    @in_pipe, @out_pipe = in_pipe, out_pipe
    @playing = true
  end

  def stop_playing
    @playing = false
  end

  def start_playing
    begin
      @in_pipe.each_line do |line|
        line = line.chomp
        case line
        when 'game_start'
          @playing = true
          assert_ready
        when 'round_start'
          round_start
        when 'win'
          game_over true
          return
        when 'loss'
          game_over false
          return
        end
        flush_output
        break unless @playing
      end
    rescue IOError => ex
      STDERR.puts "EX IO: #{ex} :: #{ex.backtrace.first}" if @playing
    rescue => ex
      STDERR.puts "EX: #{ex}\n"
    ensure
      flush_output
    end
  end

  private

  def assert_ready
    @out_pipe.puts 'ready'
  end

  def round_start
    move_by movement_vector
  end

  def move_by movement_vector
    x, y = movement_vector
    @out_pipe.puts "m #{x} #{y}"
  end

  def game_over won
    @in_pipe.close rescue nil
    @out_pipe.close rescue nil
  end

  def movement_vector
    [0,0].tap do |new_move|
      move_options.each_with_index do |possible_move_vector, i|
        if rand(100) < @move_chances[i]
          new_move[0] += possible_move_vector[0]
          new_move[1] += possible_move_vector[1]
        end
      end
      constrain new_move
    end
  end

  def constrain mv
    mv[0] = [-1, [1, mv[0]].min].max
    mv[1] = [-1, [1, mv[1]].min].max
  end

  def move_options
    [[0,1],[1,0],[0,-1],[-1,0],[-1,-1],[1,1]]
  end

  def flush_output
    @out_pipe.flush
    true
  rescue IOError
    false
  end
end

