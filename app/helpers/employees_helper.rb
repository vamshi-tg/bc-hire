module EmployeesHelper
    def is_manager?(user)
        Employee.is_manager?(user)
    end
end