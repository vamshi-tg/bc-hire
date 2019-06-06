class ApplicationsController < ApplicationController
    def index
        @applications = Application.paginate(page: params[:page], per_page: 10)
    end

    def show
        applications = Application.eager_load(:candidate).where(id: params[:id])
        @application = applications.first
    end

    def create_interview
        
    end
end
