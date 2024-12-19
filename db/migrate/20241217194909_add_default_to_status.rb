class AddDefaultToStatus < ActiveRecord::Migration[8.0]
  def up
    change_column_default :maintenance_services, :status, from: nil, to: 0
  end

  def down
    change_column_default :maintenance_services, :status, from: 0, to: nil
  end
end
