# A game which is simple
# in the form of a simulation
# where you provide the chance # of the player
# taking actions

# GAME: find the ball
# you are on a grid
# somewhere on that grid is a ball
# you can walk north, east, south or west
# you can choose to move in more than one direction
# if you occupy the same cell as the ball, you have found it

require 'darwinning'
require_relative './simulation'

class BallFinder < Darwinning::Organism

  @@sim_loops = 35

  @name = "BallFinder"
  @genes = [
    Darwinning::Gene.new(name: "chance of north", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of east", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of south", value_range: (0..100)),
    Darwinning::Gene.new(name: "chance of west", value_range: (0..100))
  ]

  def fitness
    sim = Simulation.new(genotypes)
    @@sim_loops.times do |count|
      sim.cycle
      if sim.game_over?
        return count+1
      end
    end
    # for some reason a high number here makes the app slow
    return 1000
  end
end

p = Darwinning::Population.new(
    organism: BallFinder, population_size: 100,
    fitness_goal: 0, generations_limit: 25
)
p.evolve!

p.best_member.nice_print # prints the member representing the solution