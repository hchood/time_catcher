class UpdateIndexes < ActiveRecord::Migration
  def up
    remove_index :activities, :name
    remove_index :categories, :name

    add_index :activities, [:name, :user_id], unique: true
    add_index :categories, [:name, :user_id], unique: true
  end

  def down
    remove_index :activities, [:name, :user_id]
    remove_index :categories, [:name, :user_id]

    add_index :activities, [:name], unique: true
    add_index :categories, [:name], unique: true
  end
end
