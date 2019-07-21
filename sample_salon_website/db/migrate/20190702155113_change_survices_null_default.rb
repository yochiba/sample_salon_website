class ChangeSurvicesNullDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :services, :servicename, :string, null: false
    change_column :services, :servicetypename, :string, null: false
    change_column :services, :serviceflg, :integer, null: false, default: 0
    change_column :services, :servicetime, :integer, null: false, default:0
  end

  def down
    change_column :services, :servicename, :string
    change_column :services, :servicetypename, :string
    change_column :services, :serviceflg, :integer
    change_column :services, :servicetime, :integer
  end
end
