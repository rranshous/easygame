# player will be told when rounds start
# player will output the vector it would like to move it
# can move one cell in any direction, including diagnal

# STDIN will receive from game engine
# game_start -- game has started
# start -- round has started
# win -- game has ended, you won
# loss -- game has ended, you lost

# we push to stdout
# m x y -- move, x and y in the range of -1 to 1

class Player

  def initialize move_chances, in_pipe, out_pipe
    @move_chances = move_chances.map(&:to_i)
    @in_pipe, @out_pipe = in_pipe, out_pipe
  end

  def start_playing
    STDERR.puts 'starting'
    @in_pipe.each_line do |line|
      line = line.chomp
      case line
      when 'game_start'
        STDERR.puts 'starting game'
      when 'start'
        round_start
      when 'win'
        game_over true
        return
      when 'loss'
        game_over false
        return
      end
    end
  end

  private

  def round_start
    move_by movement_vector
  end

  def move_by movement_vector
    x, y = movement_vector
    @out_pipe.puts "m #{x} #{y}"
  end

  def game_over won
    STDERR.puts 'game over!'
    STDERR.puts "We won!" if won
  end

  def movement_vector
    [0,0].tap do |to_move|
      move_options.each_with_index do |vector, i|
        if rand(100) < @move_chances[i]
          to_move[0] += vector[0]
          to_move[1] += vector[1]
        end
      end
    end
  end

  def move_options
    [[0,1],[1,0],[0,-1],[-1,0],[-1,-1],[1,1]]
  end
end
