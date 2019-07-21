class AppointmentsAddStarttokenidChangeAppointmenttokenName < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :starttokenid , :string, nil: false
    rename_column :appointments, :appointmenttoken, :totaltoken
  end

  def down
    remove_column :appointments, :starttokenid , :string, nil: false
    rename_column :appointments, :totaltoken, :appointmenttoken
  end
end
