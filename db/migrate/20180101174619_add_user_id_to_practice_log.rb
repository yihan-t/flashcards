class AddUserIdToPracticeLog < ActiveRecord::Migration[5.1]
  def change
    add_column :practice_logs, :user_id, :string
  end
end
