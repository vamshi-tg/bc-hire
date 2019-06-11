class StaticPagesController < ApplicationController
  before_action :redirect_to_login, only: [:home]

  def home
  end

  private
    def redirect_to_login
      redirect_to login_url if !logged_in?
    end
end
