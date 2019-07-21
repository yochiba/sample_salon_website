class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :servicename
      t.timestamp :appointmentdate

      t.timestamps
    end
  end
end
