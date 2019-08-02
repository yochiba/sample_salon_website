class ServicesRemoveServiceFlg < ActiveRecord::Migration[5.2]
  def up
    remove_column :services, :serviceflg, :integer
  end

  def down
    add_column :services, :serviceflg, :integer
  end
end
