class TopicFeedback < ApplicationRecord
  belongs_to :interview

  validates :name, uniqueness: {scope: [:name, :interview_id]}
end
