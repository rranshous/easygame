require 'open3'

class PlayerProxy
  def initialize exec_path
    @exec_path = exec_path
    @player_proc = nil
  end

  def next_move
    @player_in.puts 'round_start'
    sleep 1
    @player_out.gets
  end

  def game_starting
    @player_in.puts 'game_start'
  end

  def game_over_you_win
    @player_in.puts 'win'
  end

  def game_over_you_lose
    @player_in.puts 'loss'
  end

  def start
    @player_in, @player_out, @player_thread = Open3.popen2(@exec_path)
  end

  def stop
    @player_in.close
    @player_out.close
  end
end
