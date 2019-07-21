class AddUseridToCustomers < ActiveRecord::Migration[5.2]
  def up
    add_column :customers, :userid, :string, null: false
  end

  def down
    remove_column :customers, :userid, :string
  end
end
