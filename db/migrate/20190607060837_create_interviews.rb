class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.string :round_name
      t.date :scheduled_on
      t.time :start_time
      t.time :end_time
      t.integer :interviewer_id
      t.references :application, foreign_key: true

      t.timestamps
    end

    add_index :interviews, [:interviewer_id, :application_id, :start_time, :end_time], unique: true, name: 'by_interviewier_and_application'
  end
end
