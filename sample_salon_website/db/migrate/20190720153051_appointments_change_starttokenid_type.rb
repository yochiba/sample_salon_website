class AppointmentsChangeStarttokenidType < ActiveRecord::Migration[5.2]
  def chabge
    remove_column :appointments, :starttokenid, :string
  end
end
