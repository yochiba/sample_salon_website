class AppointmentsAddTotalserviceprice < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :totalserviceprice, :integer, nill: false, default: 0
  end

  def down
    remove_column :appointments, :totalserviceprice, :integer, nill: false, default: 0
  end
end
