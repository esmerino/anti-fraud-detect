class CreateScoreAntiFrauds < ActiveRecord::Migration[7.0]
  def change
    create_table :score_anti_frauds do |t|
      t.decimal :max, precision: 15, scale: 2
      t.decimal :median, precision: 15, scale: 2
      t.decimal :min, precision: 15, scale: 2

      t.timestamps
    end
  end
end
