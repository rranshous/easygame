require_relative './simulation'
require_relative './player_proxy'
player_path = ARGV.shift
puts "player command: #{player_path}"
player_proxy = PlayerProxy.new player_path
sim = SlopeSimulation.new player_proxy
Timeout::timeout(5) do
  player_proxy.start_proxy
  puts "running simulation"
  1000.times do |i|
    print "#{i} "
    sim.cycle
    if sim.game_over?
      puts "GAME OVER: #{i}"
      break
    end
  end
end
