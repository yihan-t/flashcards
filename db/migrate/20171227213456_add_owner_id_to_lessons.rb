class AddOwnerIdToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :owner_id, :integer
  end
end
