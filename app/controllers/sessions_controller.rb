class SessionsController < ApplicationController
    layout "login", only: [:new]

    skip_before_action :authenticate
    
    def new
    end

    def home
        if logged_in?
            redirect_to applications_path
        else
            redirect_to login_url
        end
    end

    def create
        @employee = Employee.find_or_create_from_auth_hash(request.env["omniauth.auth"])
        log_in @employee
        redirect_to applications_path
    end

    def destroy
        logout
        redirect_to login_url
    end
end
  