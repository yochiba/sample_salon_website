class AppointmentsRenameDisplaytimeToDisplaydate < ActiveRecord::Migration[5.2]
  def up
    rename_column :appointments, :displaytime, :displaydate
  end

  def down
    rename_column :appointments, :displaydate, :displaytime
  end
end
