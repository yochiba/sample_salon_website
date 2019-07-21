class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :adminid
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
