class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.string :plate_number, null: false, unique: true
      t.string :model_number, null: false
      t.date :year, null: false

      t.index :plate_number, unique: true

      t.timestamps
    end
  end
end
