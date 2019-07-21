class AddServicekeywordServices < ActiveRecord::Migration[5.2]
  def up
    add_column :services, :servicekeyword, :string, null: false
  end

  def down
    remove_column :services, :servicekeyword, :string, null: false
  end
end
