class RemovePropertiesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :properties
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
