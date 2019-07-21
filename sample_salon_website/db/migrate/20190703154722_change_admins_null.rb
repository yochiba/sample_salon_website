class ChangeAdminsNull < ActiveRecord::Migration[5.2]
  def up
    change_column :admins, :adminid, :string, null: false
    change_column :admins, :lastname, :string, null: false
    change_column :admins, :firstname, :string, null: false
    change_column :admins, :email, :string, null: false
    change_column :admins, :password_digest, :string, null: false
  end

  def down
    change_column :admins, :adminid, :string, null: true
    change_column :admins, :lastname, :string, null: true
    change_column :admins, :firstname, :string, null: true
    change_column :admins, :email, :string, null: true
    change_column :admins, :password_digest, :string, null: true
  end
end
