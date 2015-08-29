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
require_relative './simulation'

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
    sim = new_simulation
    @@sim_loops.times do |count|
      sim.cycle
      if sim.game_over?
        return count+1
      end
    end
    # TODO: checkout: a high number here makes the app slow
    return 1000
  end
  def new_simulation
    SlopeSimulation.new(genotypes)
  end
end

p = Darwinning::Population.new(
    organism: SlopeBallFinder, population_size: 35,
    fitness_goal: 0, generations_limit: 45
)
p.evolve!

p.best_member.nice_print # prints the member representing the solution
