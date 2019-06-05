class Application < ApplicationRecord
  belongs_to :candidate

  validates :role, presence: true
  validates :experience, presence: true
  
end
