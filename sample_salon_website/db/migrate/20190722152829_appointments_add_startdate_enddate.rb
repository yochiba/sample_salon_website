class AppointmentsAddStartdateEnddate < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :startdate, :date, nil: false
    add_column :appointments, :starttime, :time, nil: false
    add_column :appointments, :displaytime, :string, nil: false
    add_column :appointments, :displaystartdate, :string, nil: false
    add_column :appointments, :displaystarttime, :string, nil: false
    add_column :appointments, :past_flg, :integer, nil: false, default: 0
  end

  def down
    remove_column :appointments, :startdate, :date, nil: false
    remove_column :appointments, :starttime, :time, nil: false
    remove_column :appointments, :displaytime, :string, nil: false
    remove_column :appointments, :displaystartdate, :string, nil: false
    remove_column :appointments, :displaystarttime, :string, nil: false
    remove_column :appointments, :past_flg, :integer, nil: false, default: 0
  end
end
