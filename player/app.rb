require_relative './player'
move_chances = ARGV.to_a
player = Player.new move_chances, STDIN, STDOUT
player.start_playing
