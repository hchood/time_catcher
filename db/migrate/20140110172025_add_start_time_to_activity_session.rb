class AddStartTimeToActivitySession < ActiveRecord::Migration
  def change
    add_column :activity_sessions, :start_time, :datetime
  end
end
