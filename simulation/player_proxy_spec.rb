require 'rspec'
require_relative 'player_proxy'

describe PlayerProxy do
  let(:player_path) { File.join(File.absolute_path('.'),
                                'player/','app.rb') }
  let(:exec_path) { "/usr/bin/ruby #{player_path} 1 1 1 1 1 1" }
  subject { described_class.new exec_path }

  context "game has started" do
    before { subject.start_proxy }
    after { subject.stop_proxy }

    it 'asserts ready' do
      Timeout::timeout(1) do
        expect(subject.game_starting).to eq true
      end
    end

    it "responds to next move" do
      Timeout::timeout(1) do
        expect(subject.next_move).to start_with('m ')
      end
    end
  end
end
