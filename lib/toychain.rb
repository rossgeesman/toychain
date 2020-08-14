require 'digest'
require 'json'

class Toychain
  attr_accessor :chain, :current_transactions

  def initialize()
    chain = []
    current_transactions = []
  end

  def new_block(proof, previous_hash = nil)
    block = {
      index: chain.length + 1,
      timestamp: Time.now.utc.to_i,
      transactions: current_transactions,
      proof: proof,
      previous_hash: previous_hash || hash_block(last_block)
    }

    current_transactions = []
    chain << block
    last_block
  end

  def new_transaction(sender, recipient, amount)
    current_transactions << {
      sender: sender,
      recipient: recipient,
      amount
    }

    last_block['index'] + 1
  end

  def my_new_function
    return 'stuff'
  end

  def hash_block(block)
    payload = block.to_json
    Digest::SHA256.hexdigest(payload)
  end

  def last_block
    chain.last
  end
end
