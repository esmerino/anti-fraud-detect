require 'sidekiq-scheduler'
require 'csv'

class CreateTransactionsWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'low', retry: true

  def perform
    transaction = Transaction.create(transactions[rand(1..transactions.size)].to_a)

    transaction_attributes = transaction.as_json(except: [:id, 
                                                          :created_at, 
                                                          :updated_at, 
                                                          :fraud_score,
                                                          :recommendation,
                                                          :has_cbk])
    transaction[0].update(fraud_score: AntiFraudService.new.score(transaction_attributes[0]))
    transaction[0].update(recommendation: AntiFraudService.new.recommendation(transaction_attributes)[0].dig(:recommendation))

    broadcast_to_transactions(transaction[0])
  end

  private

  attr_accessor :transactions

  def transactions
    @transactions ||= Rover.read_csv(Rails.root.join('db', 'data','transactions.csv'))
  end

  def broadcast_to_transactions(transaction)
    Turbo::StreamsChannel.broadcast_replace_to("transactions",
                                               target: 'loading-transaction',
                                               partial: 'transactions/transaction',
                                               locals: { transaction: transaction })
  end
end
