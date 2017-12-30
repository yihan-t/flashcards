class CreateVocabs < ActiveRecord::Migration[5.0]
  def change
    create_table :vocabs do |t|
      t.integer :lesson_id
      t.string :english
      t.string :chinese
      t.string :notes
      t.integer :e2c_w
      t.integer :e2c_l
      t.integer :c2e_w
      t.integer :c2e_l
      t.integer :owner_id

      t.timestamps

    end
  end
end
