require 'rspec'
require_relative './player'

describe Player do

  let(:move_chances) { [10,60,20,30,40,25] }
  let(:player_to_sim) { IO.pipe }
  let(:r_player_to_sim) { player_to_sim[0] }
  let(:w_player_to_sim) { player_to_sim[1] }
  let(:sim_to_player) { IO.pipe }
  let(:r_sim_to_player) { sim_to_player[0] }
  let(:w_sim_to_player) { sim_to_player[1] }

  before do
    @t = Thread.new { subject.start_playing }
    sleep 0.1
  end
  after do
    Thread.kill @t
    r_player_to_sim.close
    w_player_to_sim.close
    r_sim_to_player.close
    w_sim_to_player.close
  end

  subject { described_class.new move_chances, r_sim_to_player, w_player_to_sim  }

  context "game is started" do
    before { w_sim_to_player.puts 'game_start' }

    it 'outputs ready' do
      Timeout::timeout(1) do
        expect(r_player_to_sim.gets.chomp).to eq 'ready'
      end
    end

    context "round is started" do
      before { r_player_to_sim.gets } # eat ready message
      before { w_sim_to_player.puts 'round_start' }

      it "outputs a move when started" do
        Timeout::timeout(1) do
          expect(r_player_to_sim.gets.chomp).to start_with('m ')
        end
      end

      it 'outputs different values' do
        Timeout::timeout(1) do
          outputs = ([nil]*10).map do
            w_sim_to_player.puts 'round_start'
            r_player_to_sim.gets.chomp
          end
          expect(outputs.uniq.length).to be > 1
        end
      end
    end
  end
end
