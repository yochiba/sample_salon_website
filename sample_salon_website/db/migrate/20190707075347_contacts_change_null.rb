class ContactsChangeNull < ActiveRecord::Migration[5.2]
  def up
    change_column :contacts, :firstname, :string, null: false
    change_column :contacts, :lastname, :string, null: false
    change_column :contacts, :email, :string, null: false
    change_column :contacts, :message, :text, null: false
  end

  def down
    change_column :contacts, :firstname, :string, null: true
    change_column :contacts, :lastname, :string, null: true
    change_column :contacts, :email, :string, null: true
    change_column :contacts, :message, :text, null: true
  end
end
