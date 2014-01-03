class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.text :description
      t.integer :time_needed_in_min, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :activities, [:name], unique: true
  end
end
