class Candidate < ApplicationRecord
    # Associations
    has_many :applications

    # Nested Attributes
    accepts_nested_attributes_for :applications

    # Validations
    validates :name, presence: true

    default_scope -> { order(created_at: :desc)}
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}    

    before_save :downcase_email

    private
        def downcase_email
            self.email = email.downcase
        end
end
