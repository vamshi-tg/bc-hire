module InterviewsHelper
    def get_name(employee)
        "#{employee.first_name} #{employee.last_name}"
    end

    def get_old_value(previous_changes, interview, field)
        previous_changes.key?(field) ? previous_changes[field][0] : interview[field]
    end
end