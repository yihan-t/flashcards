class AddTranslateToPiles < ActiveRecord::Migration[5.1]
  def change
    add_column :piles, :translate, :string
  end
end
