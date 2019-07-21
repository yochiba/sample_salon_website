class AppointmentsAddServicetime < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :totalservicetime, :integer, null: false, default: 0
  end

  def down
    remove_column :appointments, :totalservicetime, :integer, null: false, default: 0
  end
end
