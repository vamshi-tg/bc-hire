module SessionsHelper
    def is_logged_in?
        !session[:emp_id].nil?
    end
    
    def log_in_as(employee)
        session[:emp_id] = employee.id
    end
end