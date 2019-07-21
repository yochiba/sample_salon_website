class AppointmentsAddStaffidEnddateChangeAppointmentdateToStratdate < ActiveRecord::Migration[5.2]
  def up
    change_column :appointments, :appointmentdate, :datetime
    rename_column :appointments, :appointmentdate, :startdate
    add_column :appointments, :enddate, :datetime, nil: false
    add_column :appointments, :staffid, :integer, nil: false
  end

  def down
    change_column :appointments, :startdate, :timestamp
    rename_column :appointments, :startdate, :appointmentdate
    remove_column :appointments, :enddate, :datetime, nil: false
    remove_column :appointments, :staffid, :integer, nil: false
  end
end
