class ServicesAddDescription < ActiveRecord::Migration[5.2]
  def up
    add_column :services, :description, :text, null: false, default: '説明はありません'
  end

  def down
    remove_column :services, :description, :text, null: false, default: '説明はありません'
  end
end
