require 'rspec'
require_relative './player_proxy'

describe PlayerProxy do
  let(:exec_path) { 'ruby ../player/player.rb 1 1 1 1 1 1' }
  subject { described_class.new exec_path }

  context "game has started" do
    before do
      subject.start
      subject.game_starting
    end
    it "responds to next move" do
      Timeout::timeout(2) {
        expect(subject.next_move).to be String
      }
    end
  end
end
