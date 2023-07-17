class ScoreAntiFraudService
  def score
    scores = []

    data[['transaction_id', 'merchant_id', 'user_id', 
          'card_number', 'transaction_date', 
          'transaction_amount', 'device_id']].each_row do |row|
      scores << { score: model.predict([row])[0] }
    end

    score_set = Rover::DataFrame.new(scores)[:score]

    {
      max: score_set.max,
      median: score_set.median,
      min: score_set.min
    }
  end

  private

  attr_accessor :data, :model

  def data
    @data ||= Rover.read_csv(Rails.root.join('db', 'data','transactions.csv'))
  end

  def model
    @model ||= IsoTree::IsolationForest.import_model("#{Rails.root.join('db', 'model','model.bin')}")
  end
end
