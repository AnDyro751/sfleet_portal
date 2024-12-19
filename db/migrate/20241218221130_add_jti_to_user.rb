class AddJtiToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
  end
end