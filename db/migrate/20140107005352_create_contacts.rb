class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :subject, null: false
      t.string :description, null: false
      t.string :email, null: false
    end

    add_index :contacts, [:email]
  end
end
