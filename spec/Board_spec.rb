#
require "./lib/Board"
describe Board do
  subject(:test_board) { described_class.new }

  describe "#place_token" do
    context "when location is invalid" do
      it "returns false and not modify board" do
        expect(test_board.place_token(-1, "O")).to eql(false)
        expect(test_board.instance_variable_get(:@board)[0]).to eql(" ")
      end
    end

    context "when location is already filled" do
      it "returns false and not modify board" do
        test_board.instance_variable_set(:@board, ["X"," ", " ", " ", " ", " ", " ", " ", " "])

        expect(test_board.place_token(0, "O")).to eql(false)
        expect(test_board.instance_variable_get(:@board)[0]).to eql("X")
      end
    end

    context "when no error" do
      it "returns true and modify board with given token" do
        expect(test_board.place_token(1, "X")).to eql(true)
        expect(test_board.instance_variable_get(:@board)[1]).to eql("X")
      end
    end
  end

  describe "#round_end?" do
    
    context "when one diagonal is matched" do
      subject(:test_board) { described_class.new }
      
      it "returns true and set winner_token correctly" do
        test_board.instance_variable_set(:@board, [
          "X", "O", " ", 
          " ", "X", "O",
          "O", "O", "X"
        ])
        expect(test_board.round_end?).to eql(true)
        expect(test_board.instance_variable_get(:@winner_token)).to eql("X")
      end
    end

    context "one horizontal is matched" do
      subject(:test_board) { described_class.new }
      
      it "when returns true and set winner_token correctly" do
        test_board.instance_variable_set(:@board, [
          "X", " ", " ", 
          "O", "O", "O",
          " ", " ", "X"
        ])
        expect(test_board.round_end?).to eql(true)
        expect(test_board.instance_variable_get(:@winner_token)).to eql("O")
      end
    end

    context "when one vertical is matched" do
      subject(:test_board) { described_class.new }
      
      it "returns true and set winner_token correctly" do
        test_board.instance_variable_set(:@board, [
          "O", " ", " ", 
          "O", "X", " ",
          "O", " ", "X"
        ])
        expect(test_board.round_end?).to eql(true)
        expect(test_board.instance_variable_get(:@winner_token)).to eql("O")
      end
    end

    context "when board is full and no winner" do
      subject(:test_board) { described_class.new }
      
      it "returns true and NOT setting winner_token" do
        test_board.instance_variable_set(:@board, [
          "O", "O", "X", 
          "X", "X", "O",
          "O", "O", "X"
        ])
        expect(test_board.round_end?).to eql(true)
        expect(test_board.instance_variable_get(:@winner_token)).to eql(nil)
      end
    end

    context "when no matching pattern" do
      subject(:test_board) { described_class.new }
      
      it "returns false and NOT setting winner_token" do
        test_board.instance_variable_set(:@board, [
          " ", "O", " ", 
          " ", " ", " ",
          " ", " ", ""
        ])
        expect(test_board.round_end?).to eql(false)
        expect(test_board.instance_variable_get(:@winner_token)).to eql(nil)
      end
    end

  end
end