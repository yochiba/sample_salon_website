class AppointmentsRemoveStarttokenid < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :starttokenid, :string
  end
end
