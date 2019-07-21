class AdminsAddUserlevelflg < ActiveRecord::Migration[5.2]
  def up
    add_column :admins, :userlevelflg, :integer, null: false, default: 0
  end

  def down
    remove_column :admins, :userlevelflg, :integer, null: false, default: 0
  end
end
