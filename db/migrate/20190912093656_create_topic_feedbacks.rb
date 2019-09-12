class CreateTopicFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_feedbacks do |t|
      t.string :name
      t.string :positives
      t.string :negatives
      t.string :candidate_level
      t.references :interview, foreign_key: true

      t.timestamps
    end
  end
end
