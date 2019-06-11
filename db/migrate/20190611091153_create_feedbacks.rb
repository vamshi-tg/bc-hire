class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :content
      t.integer :interviewer_id
      t.references :interview, foreign_key: true

      t.timestamps
    end
  end
end
