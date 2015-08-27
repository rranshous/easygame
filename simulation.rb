class FlatSimulation

  @@board_size = 10

  def initialize move_chance
    @move_chance = move_chance.map(&:to_i)
    @player_location = [0,0]
    @ball_location = [0,0]
    @game_over = false
    randomize_board
  end

  def cycle
    move_player_by player_movement_vector
    keep_player_on_board
    @game_over ||= game_over?
  end

  def game_over?
    @game_over || @player_location == @ball_location
  end

  def print_board
    @@board_size.times do |x|
      @@board_size.times do |y|
        if [x,y] == @player_location
          print '*'
        elsif [x,y] == @ball_location
          print '.'
        else
          print '#'
        end
      end
      puts
    end
    puts
  end

  private

  def move_options
    [[0,1],[1,0],[0,-1],[-1,0]]
  end

  def player_movement_vector
    [0,0].tap do |movement_vector|
      move_options.each_with_index do |vector, i|
        if rand(100) < @move_chance[i]
          movement_vector[0] += vector[0]
          movement_vector[1] += vector[1]
        end
      end
    end
  end

  def randomize_board
    place_ball
    place_player
  end

  def place_ball
    @ball_location = [rand(@@board_size), rand(@@board_size)]
  end

  def place_player
    @player_location = [rand(@@board_size), rand(@@board_size)]
  end

  def keep_player_on_board
    @player_location[0] = [0, [@player_location[0], @@board_size-1].min].max
    @player_location[1] = [0, [@player_location[1], @@board_size-1].min].max
  end

  def move_player_by vector
    @player_location[0] += vector[0]
    @player_location[1] += vector[1]
  end
end


class SlopeSimulation < FlatSimulation

  def place_ball
    @ball_location[0] *= 0.5
    @ball_location[1] *= 0.5
  end

  def player_movement_vector
    super.tap do |vector|
      go_uphill = rand(100) < @move_chance[-2]
      go_downhill = rand(100) < @move_chance[-1]
      if go_uphill && !go_downhill
        vector[0] = 1 and vector[1] = 1
      elsif go_downhill && !go_uphill
        vector[0] = -1 and vector[1] = -1
      end
    end
  end
end
