require 'rails_helper'

RSpec.describe ScoreAntiFraud, type: :model do
  describe '.create' do
    transaction = FactoryBot.create(:score_anti_fraud)

    it { expect(transaction).to be_valid }
  end
end
