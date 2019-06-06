class RemoveExperienceFromCandidates < ActiveRecord::Migration[5.1]
  def change
    remove_column :candidates, :experience, :integer
  end
end
