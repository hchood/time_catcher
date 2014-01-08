class CreateActivitySessions < ActiveRecord::Migration
  def change
    create_table :activity_sessions do |t|
      t.integer :activity_id, null: false
      t.integer :time_available, null: false
      t.datetime :finished_at
      t.integer :duration_in_seconds

      t.timestamps
    end
  end
end
