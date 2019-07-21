class AppointmentsAddStarttokenid < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :starttokenid, :integer, nil: false, default: 0
  end

  def down
    remove_column :appointments, :starttokenid, :integer, nil: false, default: 0
  end
end
