require 'csv'

CSV.foreach(Rails.root.join('db', 'data','transactions.csv'), headers: true) do |row|
  transaction = Transaction.create(row)
end
