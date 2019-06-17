class SessionsController < ApplicationController
    layout "login", only: [:new]

    before_action :redirect_to_root, only: [:new]

    skip_before_action :authenticate
    
    def new
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

    private
        def redirect_to_root
            redirect_to root_path if logged_in?
        end
end
  