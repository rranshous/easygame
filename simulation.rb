class Simulation

  @@board_size = 10

  def initialize move_chance
    @move_chance = move_chance.map(&:to_i)
    @player_location = [0,0]
    @ball_location = [0,0]
    @game_over = false
    randomize_board
  end

  def cycle
    [[0,1],[1,0],[0,-1],[-1,0]].each_with_index do |vector, i|
      if rand(100) < @move_chance[i]
        @player_location[0] += vector[0]
        @player_location[1] += vector[1]
      end
    end

    keep_player_on_board
    @game_over ||= game_over?
  end

  def keep_player_on_board
    @player_location[0] = [0, [@player_location[0], @@board_size-1].min].max
    @player_location[1] = [0, [@player_location[1], @@board_size-1].min].max
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

  def randomize_board
    @player_location = [rand(@@board_size), rand(@@board_size)]
    @ball_location = [rand(@@board_size), rand(@@board_size)]
  end
end


#puts 'starting'
#sim = Simulation.new(ARGV[0..3])
#sim.print_board
#loop do
#  sim.cycle
#  sleep(1)
#end
#puts 'ending'
