class Employee < ApplicationRecord
    has_many :interviews, class_name: "Interview", foreign_key: "interviewer_id"
	has_many :feedback, class_name: "Feedback", foreign_key: "interviewer_id"
	has_many :applications, class_name: "Application", foreign_key: "owner_id"
	has_one :permission, dependent: :destroy
	
	has_many :involved_applications, through: :interviews, source: :application

	ROLE = {
		manager: "manager",
		interviewer: "interviewer"
	}

	def google_token_expired?
		self.google_token_expires_at < Time.current.to_i
	end

    def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |employee|
			employee.provider = auth.provider
			employee.uid = auth.uid
			employee.name = auth.info.name
			employee.email = auth.info.email
			employee.picture = auth.info.image
			employee.google_token = auth.credentials.token
			employee.google_token_expires_at = auth.credentials.expires_at.to_i
			refresh_token = auth.credentials.refresh_token
			employee.refresh_token = refresh_token if refresh_token.present?
			employee.save!
        end
	end
	
	def self.managers_email_ids
		Employee.select(:email).where(role: ROLE[:manager]).map{ |employee| employee.email}
	end

	def self.is_manager?(employee)
		employee.role == ROLE[:manager]
	end
end
