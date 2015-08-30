# A game which is simple
# in the form of a simulation
# where you provide the chance # of the player
# taking actions

# GAME: find the can
# you are on a grid
# somewhere on that grid is a can
# the can is more likely to be toward the bottom of the slope
# you can walk north, east, south, west, uphill and downhill
# you can choose to move in more than one direction
# if you occupy the same cell as the can, you have found it

require 'darwinning'
require_relative './simulation/simulation'
require_relative './simulation/player_proxy'
require_relative './player/player'

class SlopeBallFinder < Darwinning::Organism
  @@sim_loops = 25
  @name = "SlopedBallFinder"
  @genes = [
    Darwinning::Gene.new(name: "chance of north", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of east", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of south", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of west", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of uphill", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of downhill", value_range: (0..100))
  ]
  def fitness
    sim, cleanup = new_simulation
    @@sim_loops.times do |count|
      sim.cycle
      if sim.game_over?
        cleanup.call
        puts "WIN: #{count}"
        return count+1
      end
    end
    # TODO: checkout: a high number here makes the app slow
    cleanup.call
    return 1000
  end

  def new_simulation
    puts 'new sim'
    r_player_to_sim, w_player_to_sim = IO.pipe
    r_sim_to_player, w_sim_to_player = IO.pipe
    player = Player.new genotypes, r_sim_to_player, w_player_to_sim
    play_thread = Thread.new(player) do |player|
      player.start_playing
    end
    player_proxy = PlayerProxy.new nil, w_sim_to_player, r_player_to_sim
    player_proxy.start_proxy
    [SlopeSimulation.new(player_proxy), ->{
      player_proxy.stop_proxy
      [r_player_to_sim, w_player_to_sim,
       r_sim_to_player, w_sim_to_player].each do |p|
        p.close rescue nil
      end
      Thread.kill play_thread
    }]
  end
end

p = Darwinning::Population.new(
    organism: SlopeBallFinder, population_size: 10,
    fitness_goal: 0, generations_limit: 10
)
p.evolve!

p.best_member.nice_print # prints the member representing the solution
