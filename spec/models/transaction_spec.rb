require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '.create' do
    transaction = FactoryBot.create(:transaction)

    it { expect(transaction).to be_valid }
  end
end
