class StaffAddPassword < ActiveRecord::Migration[5.2]
  def up
    add_column :staffs, :password_digest, :string, null: false
    add_column :staffs, :staffid, :string, null: false
  end

  def down
    remove_column :staffs, :password_digest, :string, null: false
    remove_column :staffs, :staffid, :string, null: false
  end
end
