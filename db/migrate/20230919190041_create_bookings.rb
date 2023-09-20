class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :property, null: false, foreign_key: true
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.string :extra_info
      t.string :access_info

      t.timestamps
    end
  end
end
