class AddUserIdToActivitySessions < ActiveRecord::Migration
  def change
    add_column :activity_sessions, :user_id, :integer
  end
end
