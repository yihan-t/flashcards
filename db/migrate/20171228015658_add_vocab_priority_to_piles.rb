class AddVocabPriorityToPiles < ActiveRecord::Migration[5.1]
  def change
    add_column :piles, :vocab_priority, :text
  end
end
