class AntiFraudService
  def recommendation(transactions)
    transactions = Rover::DataFrame.new(transactions.as_json)
    validations = []
    transactions.each_row do |transaction|
      if user_trying_many(transactions, transaction['user_id'], transaction['transaction_id'])
        validations << deny(transaction['transaction_id'])
      elsif above_amount_period(transaction['transaction_date'], transaction['transaction_amount'], transaction['transaction_id'])
        validations << deny(transaction['transaction_id'])
      elsif user_has_cbk(transaction['user_id'], transaction['transaction_id'])
        validations << deny(transaction['transaction_id'])
      elsif score_limit(transaction, transaction['transaction_id'])
        validations << deny(transaction['transaction_id'])
      else
        validations << { transaction_id: transaction['transaction_id'], recommendation: 'approve' } 
      end
    end
    validations
  end

  def score(transaction)
    model.predict([TransactionStruct.new(transaction).attributes])[0]
  end

  private

  attr_accessor :model

  def user_trying_many(transactions, user_id, transaction_id)
    transactions.group('user_id').count.to_a.map{|a| a['user_id'] == user_id && a['count'] > 1 }.include?(true)
  end

  def above_amount_period(transaction_date, transaction_amount, transaction_id)
    period_limt = Time.now.change(hour: 23, min: 59, sec: 59)
    amound_limit = 1000.00

    transaction_amount.to_f > amound_limit && transaction_date.to_time > period_limt
  end

  def user_has_cbk(user_id, transaction_id)
    Transaction.exists?(user_id: user_id, has_cbk:'TRUE')
  end

  def score_limit(transaction, transaction_id)
    model.predict([TransactionStruct.new(transaction).attributes])[0] > median_score
  end

  def median_score
     ScoreAntiFraud.last&.median&.to_f || 0.41
  end

  def approve(transaction_id)
    { transaction_id: transaction_id, recommendation: 'approve' } 
  end

  def deny(transaction_id)
    { transaction_id: transaction_id, recommendation: 'deny' } 
  end

  def model
    @model ||= IsoTree::IsolationForest.import_model("#{Rails.root.join('db', 'model','model.bin')}")
  end
end
