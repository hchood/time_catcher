class AddSkippedCountToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :skipped_count, :integer, default: 0
  end
end
