FactoryBot.define do
  factory :score_anti_fraud do
    max { "0.50" }
    median { "0.41" }
    min { "0.30" }
  end
end
