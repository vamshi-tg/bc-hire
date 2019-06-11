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
        @interviews = @application.interviews.order(:created_at)
        @interview = @interviews.find_by(id: params[:interview_id])
        @comments = Feedback.where(interview_id: params[:interview_id]).order(:created_at)
    end

    def update
        @application = Application.find_by(id: params[:id])
        if @application.update_attributes(application_params)
            flash[:success] = "Application Status Updated"
            redirect_to @application
        else
            flash[:danger] = "Failed to update"
        end
    end

    def search
        search_query = params[:search]
        if search_query.present?
            conditions = 'candidates.name LIKE :query OR candidates.email LIKE :query OR applications.experience LIKE :query OR applications.role LIKE :query'
            @applications = Application.eager_load(:candidate).where(conditions, query: "%#{search_query}%").paginate(page: params[:page], per_page: 10)
            render 'index'
        else
            redirect_to applications_path
        end
    end

    private
        def application_params
            params.require(:application).permit(:status)
        end
end
