class RemoveUniqueIndexFromApplications < ActiveRecord::Migration[5.1]
  def change
    remove_index :applications, ["candidate_id", "role"]
  end
end
