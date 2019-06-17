class StaticPagesController < ApplicationController
  before_action :redirect_to_login, only: [:home]

  skip_before_action :authenticate

  private
    def redirect_to_login
      redirect_to login_url if !logged_in?
    end
end
