class TransactionStruct
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :transaction_id, :integer
  attribute :merchant_id, :integer
  attribute :user_id, :integer
  attribute :card_number, :string
  attribute :transaction_date, :string
  attribute :transaction_amount, :float
  attribute :device_id, :float
end