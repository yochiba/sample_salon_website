class ServicesAddServiceimage < ActiveRecord::Migration[5.2]
  def up
    add_column :services, :serviceimage, :string, nill: false, default: "default.jpg"
  end

  def down
    remove_column :services, :serviceimage, :string, nill: false, default: "default.jpg"
  end
end
