class SessionsController < ApplicationController
    def create
        @employee = Employee.find_or_create_from_auth_hash(request.env["omniauth.auth"])
        log_in @employee
        redirect_to applications_path
    end

    def destroy
        logout
        redirect_to root_path
    end
end
  