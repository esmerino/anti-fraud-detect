# frozen_string_literal: true

namespace :anti_fraud do
  desc 'Update Score Anti Fraud'
  task update_score_anti_fraud: [:environment] do
    Rails.logger.info '[update_score_media task] start!'

    ScoreAntiFraud.create(ScoreAntiFraudService.new.score)

    Rails.logger.info '[update_score_media task] finished!'
  end

  desc 'Update Model'
  task update_model_anti_fraud: [:environment] do
    Rails.logger.info '[update_model_anti_fraud task] start!'

    data = Rover.read_csv(Rails.root.join('db', 'data','transactions.csv'))
    model = IsoTree::IsolationForest.new
    model.fit(data[['transaction_id', 'merchant_id', 'user_id', 'card_number', 'transaction_date', 'transaction_amount', 'device_id']])
    model.export_model("#{Rails.root.join('db', 'model','model.bin')}")

    Rails.logger.info '[update_model_anti_fraud task] finished!'
  end
end
