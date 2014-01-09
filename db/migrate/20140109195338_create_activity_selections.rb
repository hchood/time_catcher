class CreateActivitySelections < ActiveRecord::Migration
  def change
    create_table :activity_selections do |t|
      t.integer :activity_id, null: false
      t.integer :activity_session_id, null: false

      t.timestamps
    end
  end
end
