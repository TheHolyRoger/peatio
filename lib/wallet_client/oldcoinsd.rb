# encoding: UTF-8
# frozen_string_literal: true

module WalletClient
  class Oldcoinsd < Bitcoind
    def create_withdrawal!(issuer, recipient, amount, options = {})
      options.merge!(subtract_fee: false) unless options.has_key?(:subtract_fee)

      json_rpc(:settxfee, [options[:fee]]) if options.key?(:fee)
      json_rpc(:walletpassphrase, [options[:secret], 60]) if options.key?(:secret) && !options[:secret].blank?
      txid = json_rpc(:sendtoaddress, [normalize_address(recipient.fetch(:address)), amount.to_f])
          .fetch('result')
          .yield_self(&method(:normalize_txid))
      json_rpc(:walletlock) if options.key?(:secret) && !options[:secret].blank?
      txid
    end
  end
end
