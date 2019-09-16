class Permission < ApplicationRecord
  belongs_to :employee

  %i[can_interview_round_1 can_interview_round_2, 
	can_interview_round_3 can_interview_round_4].each do |field|
		define_method("#{field}?".to_sym) do
			self.send(field)
		end
	end
end
