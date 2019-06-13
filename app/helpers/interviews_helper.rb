module InterviewsHelper
    def get_name(employee)
        "#{employee.first_name} #{employee.last_name}"
    end

    def get_interviewers_assocaited_with_application(application_id)
      application = Application.includes({interviews: :interviewer}).find(application_id)
      associated_interviewers = application.interviews.map do |interview|
        interview.interviewer.email
      end

      associated_interviewers.uniq
      return associated_interviewers
    end

    def get_employees_associated_with_application(application_id)
      interviewers = get_interviewers_assocaited_with_application(application_id)
      employees = append_managers(interviewers)
    end
  
    def append_managers(interviewers)
      managers = Employee.managers_email_ids
      employees = interviewers.push(*managers)
      return employees
    end

    def user_associated_with_applicaiton?(user, application)
        associated = get_employees_associated_with_application(application.id).include? user.email
    end
end