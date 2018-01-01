class CreatePracticeLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :practice_logs do |t|
      t.integer :vocab_id
      t.integer :pile_id
      t.string :practice_type
      t.integer :win
      t.integer :loss

      t.timestamps
    end
  end
end
