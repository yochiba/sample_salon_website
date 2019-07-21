class ServicesAddServiceprice < ActiveRecord::Migration[5.2]
  def up
    add_column :services, :serviceprice, :integer, null: false
  end

  def down
    remove_column :services, :serviceprice, :integer, null: false
  end
end
