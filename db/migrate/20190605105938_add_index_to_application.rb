class AddIndexToApplication < ActiveRecord::Migration[5.1]
  def change
    add_index :applications, [:candidate_id, :role], unique: true
  end
end
