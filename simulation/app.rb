require_relative './simulation'
require_relative './player_proxy'
player_path = ARGV.shift
player_proxy = PlayerProxy.new player_path
sim = SlopeSimulation.new player_proxy
