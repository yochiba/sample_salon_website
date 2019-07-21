class StaffsChangeDisplaynameNullDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :staffs, :displayname, :string, nil: false, default: "Noname"
  end

  def down
    change_column :staffs, :displayname, :string, nil: true, default: nil
  end
end
