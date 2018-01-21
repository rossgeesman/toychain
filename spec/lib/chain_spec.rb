require 'chain'
require 'pry'
RSpec.describe Chain do
  subject { Chain.new }
  describe '#new' do
    it 'should not have transactions' do
      expect(subject.current_transactions).to be_empty
    end

    it "should have a proof_prefix string calculated from the difficulty" do
      expect(subject.proof_prefix).to eq("00")
    end

    it 'should have a genesis block' do
      expect(subject.history.length).to eq(1)
    end
  end

  describe "#proof_of_work" do
    it 'returns a hex digest string' do
      expect(subject.proof_of_work('randominput')).to be_an_instance_of(Integer)
    end

    it 'calls #valid_proof?' do
      expect(subject).to receive(:valid_proof?).at_least(1).times
      subject.proof_of_work('randominput')
    end
  end


end

