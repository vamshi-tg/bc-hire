class Candidate < ApplicationRecord
    # Associations
    has_many :applications

    # Validations
    validates :name, presence: true
    
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
