class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.integer :experience
      t.string :role
      t.references :candidate, foreign_key: true

      t.timestamps
    end
  end
end
