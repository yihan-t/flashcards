class RemoveFieldNameFromTableName < ActiveRecord::Migration[5.1]
  def change
    remove_column :lessons, :owner, :string
  end
end
