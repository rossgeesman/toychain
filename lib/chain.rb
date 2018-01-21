require 'digest'
require 'json'

class Chain
  attr_accessor :history, :current_transactions, :difficulty, :proof_prefix

  def initialize(difficulty = 2)
    @history = []
    @current_transactions = []
    @difficulty = difficulty
    @proof_prefix = ''

    set_proof_prefix
    new_block(previous_hash=1, proof=100)
  end

  def set_proof_prefix
    difficulty.times do
      proof_prefix << '0'
    end
  end

  def new_block(proof, previous_hash = nil)
    block = {
      index: history.length + 1,
      timestamp: Time.now.utc.to_i,
      transactions: current_transactions,
      proof: proof,
      previous_hash: previous_hash || hash_block(last_block)
    }

    current_transactions = []
    history << block
    last_block
  end

  def proof_of_work(prev_proof)
    proof = 0
    while !valid_proof?(prev_proof, proof)
      proof += 1
    end
    proof
  end

  def valid_proof?(prev_proof, proof)
    binding.pry
    guess_hash = hash_block("#{prev_proof}#{proof}")
    guess_hash[0..(difficulty - 1)] == proof_prefix
  end

  def new_transaction(sender, recipient, amount)
    current_transactions << {
      sender: sender,
      recipient: recipient,
      amount: amount
    }

    last_block['index'] + 1
  end

  def hash_block(block)
    payload = block.to_json
    Digest::SHA256.hexdigest(payload)
  end

  def last_block
    history.last
  end
end