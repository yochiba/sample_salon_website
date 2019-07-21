class AppointmentsAddAppointmentToken < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :appointmenttoken, :integer, null: false, default: 0
  end

  def down
    remove_column :appointments, :appointmenttoken, :integer, null: false, default: 0
  end
end
