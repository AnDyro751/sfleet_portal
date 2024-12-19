class CreateMaintenanceServices < ActiveRecord::Migration[8.0]
  def change
    create_table :maintenance_services do |t|
      t.references :car, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :status, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
