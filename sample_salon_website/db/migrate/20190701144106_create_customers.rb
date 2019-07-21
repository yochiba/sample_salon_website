class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :firstname
      t.string :lastname
      t.integer :gender
      t.integer :age
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
