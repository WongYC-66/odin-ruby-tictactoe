#
require "./lib/Game"
require "./lib/Board"
require "./lib/Player"

describe Game do
  subject(:test_game) { described_class.new }

  describe "#game_end" do
    context "when round exceeds max_round" do
      subject(:test_game) { described_class.new(9) }
      it "returns true" do
        test_game.instance_variable_set(:@curr_round, 10)
        expect(test_game.game_end?).to eql(true)
      end
    end

    context "when round below or equal max_round" do
      subject(:test_game) { described_class.new(9) }
      it "returns false" do
        test_game.instance_variable_set(:@curr_round, 7)
        expect(test_game.game_end?).to eql(false)
      end
    end
  end

  describe "#ask_and_place" do
    context "when place_token" do
      subject(:test_game) { described_class.new(9, board_instance) }
      let(:board_instance) { instance_double(Board) }

      before do
        allow(board_instance).to receive(:place_token).and_return(true, false)
      end

      it "inverts turn correctly based on place_token return" do
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:gets)

        test_game.ask_and_place()
        expect(test_game.instance_variable_get(:@turn)).to eql(false)

        test_game.ask_and_place()
        expect(test_game.instance_variable_get(:@turn)).to eql(false)
      end
    end
  end

  describe "#play" do

    subject(:test_game) { described_class.new(9, board_instance) }
    let(:board_instance) { instance_double(Board) }

    before do
      allow(test_game).to receive(:game_end?).and_return(false, false, true)
      allow(test_game).to receive(:print_game_result)
      allow(test_game).to receive(:print_game_status)
      allow(test_game).to receive(:ask_and_place)
      allow(test_game).to receive(:check_round_end)
      allow(test_game).to receive(:new_round)
      allow(board_instance).to receive(:print_board)
    end
    
    context "when game is not ending" do
      it "run the game at least once" do
        expect(test_game).to receive(:print_game_status).twice
        expect(test_game).to receive(:ask_and_place).twice
        expect(test_game).to receive(:check_round_end).twice
        expect(board_instance).to receive(:print_board).twice

        expect(test_game).to receive(:print_game_result).once

        test_game.play()
      end
    end
  end

  describe "#check_round_end" do

    subject(:test_game) { described_class.new(9, board_instance) }
    let(:board_instance) { instance_double(Board) }

    before do
      allow(test_game).to receive(:puts)
      allow(test_game).to receive(:new_round)
    end
    
    context "when round no yet ends" do
      it "does not changes game state" do
        allow(board_instance).to receive(:round_end?).and_return(false)
        test_game.check_round_end()
        expect(test_game.instance_variable_get(:@curr_round)).to eql(1)
      end
    end

    context "current round is ending" do
      let(:tie_msg) {"It's a tie, nobody has won"}
      let(:player_1_win_msg) {"Player_1 got it!"}
      let(:player_2_win_msg) {"Player_2 got it!"}

      it "prints tie message" do
        allow(board_instance).to receive(:round_end?).and_return(true)
        allow(board_instance).to receive(:winner_token).and_return(nil) 
        expect(test_game).to receive(:puts).with(tie_msg).once
        test_game.check_round_end()
      end

      it "prints winning message for player_1" do
        allow(board_instance).to receive(:round_end?).and_return(true)
        allow(board_instance).to receive(:winner_token).and_return("O") 
        expect(test_game).to receive(:puts).with(player_1_win_msg).once
        test_game.check_round_end() # true-round-with-O
      end

      it "prints winning message for player_2" do
        allow(board_instance).to receive(:round_end?).and_return(true)
        allow(board_instance).to receive(:winner_token).and_return("X") 
        expect(test_game).to receive(:puts).with(player_2_win_msg).once
        test_game.check_round_end() # true-round-with-X
      end
    end

  end

  describe "#print_game_result" do
    subject(:test_game) { described_class.new(9, nil, double_p1, double_p2) }
    let(:tie_msg) { "Game Ended. No winner, it's a tie!" }
    let(:p1_win_msg) { "Game Ended. Winner : Player 1!" }
    let(:p2_win_msg) { "Game Ended. Winner : Player 2!" }
    let(:double_p1) { Player.new("Player_1", "O") }
    let(:double_p2) { Player.new("Player_2", "X") }
  
    before do
      allow(test_game).to receive(:puts)
      allow(test_game).to receive(:print_game_status)
    end

    context "there is a tie" do
      it "prints tie message" do
        double_p1.score = 3
        double_p2.score = 3
        expect(test_game).to receive(:puts).with(tie_msg).once
        test_game.print_game_result()
      end
    end

    context "player1 has more score" do
      it "prints player1 win message" do
        double_p1.score = 7
        double_p2.score = 3
        expect(test_game).to receive(:puts).with(p1_win_msg).once
        test_game.print_game_result()
      end
    end

    context "player2 has more score" do
      it "prints player1 win message" do
        double_p1.score = 3
        double_p2.score = 7
        expect(test_game).to receive(:puts).with(p2_win_msg).once
        test_game.print_game_result()
      end
    end
  end
end