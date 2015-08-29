class FlatSimulation

  @@board_size = 10

  def initialize player_proxy
    @player_proxy = player_proxy
    @player_location = [0,0]
    @ball_location = [0,0]
    @game_over = false
    @started = false
    randomize_board
  end

  def cycle
    announce_game_start unless @started
    @started ||= true
    move_player_by player_movement_vector
    keep_player_on_board
    @game_over ||= game_over?
    announce_winner if @game_over
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

  def announce_game_start
    @player_proxy.game_starting
  end

  def announce_winner
    @player_proxy.game_over_you_win
  end

  def move_options
    [[0,1],[1,0],[0,-1],[-1,0]]
  end

  def player_movement_vector
    @player_proxy.next_move
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
end
