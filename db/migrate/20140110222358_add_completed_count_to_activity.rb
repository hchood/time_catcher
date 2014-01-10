class AddCompletedCountToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :completed_count, :integer, default: 0
  end
end
