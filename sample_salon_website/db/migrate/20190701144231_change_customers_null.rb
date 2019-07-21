class ChangeCustomersNull < ActiveRecord::Migration[5.2]
  def up
    change_column :customers, :firstname, :string, null: false
    change_column :customers, :lastname, :string, null: false
    change_column :customers, :email, :string, null: false
    change_column :customers, :password_digest, :string, null: false
  end

  def down
    change_column :customers, :firstname, :string, null: true
    change_column :customers, :lastname, :string, null: true
    change_column :customers, :email, :string, null: true
    change_column :customers, :password_digest, :string, null: true
  end
end
