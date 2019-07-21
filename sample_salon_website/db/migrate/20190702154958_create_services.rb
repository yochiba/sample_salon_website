class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :servicename
      t.string :servicetypename
      t.integer :serviceflg
      t.integer :servicetime

      t.timestamps
    end
  end
end
