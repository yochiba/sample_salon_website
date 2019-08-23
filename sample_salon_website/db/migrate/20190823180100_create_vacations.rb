class CreateVacations < ActiveRecord::Migration[5.2]
  def change
    create_table :vacations do |t|
      t.integer :typeflg
      t.text :message
      t.integer :staffid
      t.string :lastname
      t.string :firstname
      t.date :vacationdate
      t.string :permitflg

      t.timestamps
    end
  end
end
