class StaffsChangeNicknameToDisplayname < ActiveRecord::Migration[5.2]
  def up
    rename_column :staffs, :nickname, :displayname
  end

  def down
    rename_column :staffs, :displayname, :nickname
  end
end
