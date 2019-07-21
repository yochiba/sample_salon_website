class ChangeAppointmentsDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :appointments, :firstname, :string, null: false, default: "pending"
    change_column :appointments, :lastname, :string, null: false, default: "pending"
    change_column :appointments, :email, :string, null: false, default: "pending@pending"
    change_column :appointments, :servicename, :string, null: false, default: "pending"
    change_column :appointments, :appointmentdate, :timestamp, null: false, default: -> { 'NOW()' }
  end

  def down
    change_column :appointments, :firstname, :string, null: false
    change_column :appointments, :lastname, :string, null: false
    change_column :appointments, :email, :string, null: false
    change_column :appointments, :servicename, :string, null: false
    change_column :appointments, :appointmentdate, :timestamp, null: false
  end
end
