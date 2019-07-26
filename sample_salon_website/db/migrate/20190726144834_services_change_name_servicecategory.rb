class ServicesChangeNameServicecategory < ActiveRecord::Migration[5.2]
  def up
    rename_column :services, :servicetypename, :servicecategory
  end

  def down
    rename_column :services, :servicecategory, :servicetypename
  end
end
