class ChangeNullAppointments < ActiveRecord::Migration[5.2]
  def up
    change_column :appointments, :firstname, :string, null: false
    change_column :appointments, :lastname, :string, null: false
    change_column :appointments, :servicename, :string, null: false
    change_column :appointments, :appointmentdate, :timestamp, null: false
  end

  def down
    change_column :appointments, :firstname, :string, null: true
    change_column :appointments, :lastname, :string, null: true
    change_column :appointments, :servicename, :string, null: true
    change_column :appointments, :appointmentdate, :timestamp, null: true
  end
end
