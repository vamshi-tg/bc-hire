class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include EmployeesHelper
  before_action :authenticate
  
  private
    def authenticate
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
