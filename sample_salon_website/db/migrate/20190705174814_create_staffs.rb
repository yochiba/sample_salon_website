class CreateStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :staffs do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :nickname

      t.timestamps
    end
  end
end
