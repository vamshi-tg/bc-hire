class ApplicationsController < ApplicationController
    before_action :logged_in_user
    
    def index
        search_query = params[:search]
        if search_query.present?
            conditions = 'candidates.name LIKE :query OR candidates.email LIKE :query'\
                         ' OR applications.experience LIKE :query OR applications.role LIKE :query'\
                         ' OR applications.status LIKE :query'
            @applications = Application.eager_load(:candidate).where(conditions, query: "%#{search_query}%").paginate(page: params[:page], per_page: 10)
        else
            @applications = Application.eager_load(:candidate).paginate(page: params[:page], per_page: 10)            
        end
    end

    def show
        applications = Application.where(id: params[:id])
        @application = applications.first
        @interviews = @application.interviews
    end

    def show_application_interview
        @application = Application.find(params[:id])
        @interviews = @application.interviews.order(:created_at)
        @interview = @interviews.find_by(id: params[:interview_id])
        @comments = @interview.feedback
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

    private
        def application_params
            params.require(:application).permit(:status, :search)
        end
end
