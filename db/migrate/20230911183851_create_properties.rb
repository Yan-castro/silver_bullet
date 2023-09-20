class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
