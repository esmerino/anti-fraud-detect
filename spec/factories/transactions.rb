FactoryBot.define do
  factory :transaction do
    transaction_id { 2342358 }
    merchant_id { 29744 }
    user_id { 97051 }
    card_number { "434505******9116" }
    transaction_date { Time.now.change(hour: 13, min: 00, sec: 0).to_s }
    transaction_amount { "MyString" }
    device_id { 2000 }
    has_cbk { "TRUE" }
    recommendation { "approve" }
  end
end
