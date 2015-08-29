require 'open3'

class PlayerProxy
  def initialize exec_path
    @exec_path = exec_path
    @player_proc = nil
  end

  def next_move
    @player_in.puts 'round_start'
    sleep 0.1 #? needed?
    @player_out.gets.split[1..2].map(&:to_i)
  end

  def game_starting
    @player_in.puts 'game_start'
    @player_out.gets.chomp == 'ready'
  end

  def game_over_you_win
    @player_in.puts 'win'
  end

  def game_over_you_lose
    @player_in.puts 'loss'
  end

  def start_proxy
    @player_in, @player_out, @player_thread = Open3.popen2(@exec_path)
    raise "no pipes?" if @player_in.nil?
  end

  def stop_proxy
    @player_in.close
    @player_out.close
  end
end
