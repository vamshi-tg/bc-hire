class SessionsController < ApplicationController
    before_action :redirect_to_home, only: [:new]

    def new
    end

    def create
        @employee = Employee.find_or_create_from_auth_hash(request.env["omniauth.auth"])
        log_in @employee
        redirect_to applications_path
    end

    def destroy
        logout
        redirect_to root_path
    end

    private
        def redirect_to_home
            redirect_to root_path if logged_in?
        end
end
  