class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.integer :merchant_id
      t.integer :user_id
      t.string :card_number
      t.string :transaction_date
      t.float :transaction_amount
      t.integer :device_id
      t.string :has_cbk
      t.decimal :fraud_score, precision: 15, scale: 2
      t.integer :recommendation, default: 0

      t.timestamps
    end
  end
end
