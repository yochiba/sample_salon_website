class AppointmentsAddStaff < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :staffname, :string, nul: false, default: "指名なし"
  end

  def down
    remove_column :appointments, :staffname, :string, nul: false, default: "指名なし"
  end
end
