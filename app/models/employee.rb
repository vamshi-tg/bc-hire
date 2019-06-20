class Employee < ApplicationRecord
    has_many :interviews, class_name: "Interview", foreign_key: "interviewer_id"
	has_many :feedback, class_name: "Feedback", foreign_key: "interviewer_id"
	has_many :applications, class_name: "Application", foreign_key: "owner_id"
	
	has_many :involved_applications, through: :interviews, source: :application

	ROLE = {
		manager: "manager",
		interviewer: "interviewer"
	}

    def self.find_or_create_from_auth_hash(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |employee|
			employee.provider = auth.provider
			employee.uid = auth.uid
			employee.first_name = auth.info.first_name
			employee.last_name = auth.info.last_name
			employee.email = auth.info.email
			employee.picture = auth.info.image
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
