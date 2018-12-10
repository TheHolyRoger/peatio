# encoding: UTF-8
# frozen_string_literal: true

module BlockchainClient
  class Oldcoins < Bitcoin
    def get_block(block_hash)
      block_json = json_rpc(:getblock, [block_hash]).fetch('result')
      block_json['tx'] = block_json.fetch('tx').map(&method(:get_raw_transaction))
      block_json
    end

    def get_raw_transaction(txid)
      json_rpc(:getrawtransaction, [txid, 1]).fetch('result')
    end
  end
end
