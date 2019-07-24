class AppointmentsChangeTime < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :startdate, :datetime
    remove_column :appointments, :enddate, :datetime
  end
end
