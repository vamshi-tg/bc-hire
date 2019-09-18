module SessionsHelper
    def log_in(employee)
        session[:emp_id] = employee.id
    end

    def logout
        session.delete(:emp_id)
        @current_user = nil
    end

    def current_user
        if session[:emp_id]
            @current_user ||= Employee.find_by(id: session[:emp_id])
        end
    end

    def logged_in?
        !current_user.nil?
    end

    def is_current_user?(user)
        current_user == user
    end
end