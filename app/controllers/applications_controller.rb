class ApplicationsController < ApplicationController
    def index
        @applications = Application.paginate(page: params[:page], per_page: 10)
    end

    def show
        applications = Application.eager_load(:candidate).where(id: params[:id])
        @application = applications.first
        @interviews = @application.interviews
    end

    def show_application_interview
        @application = Application.find_by(id: params[:id])
        @interviews = @application.interviews
        @interview = @interviews.find_by(id: params[:interview_id])
    end
end
