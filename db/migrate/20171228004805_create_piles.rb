class CreatePiles < ActiveRecord::Migration[5.0]
  def change
    create_table :piles do |t|
      t.string :user_id
      t.text :vocab
      t.text :vocab_w
      t.text :vocab_l

      t.timestamps

    end
  end
end
