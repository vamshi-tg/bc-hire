class AddColumnToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :owner_id, :integer
  end
end
