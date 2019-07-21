class AppointmentsAddDisplayname < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :displaytime, :string, nil: false, default: "nodisplay time"
  end

  def down
    remove_column :appointments, :displaytime, :string, nil: false, default: "nodisplay time"
  end
end
