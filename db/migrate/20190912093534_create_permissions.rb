class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.boolean :can_interview_round_1, default: false
      t.boolean :can_interview_round_2, default: false
      t.boolean :can_interview_round_3, default: false
      t.boolean :can_interview_round_4, default: false

      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
