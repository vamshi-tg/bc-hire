class ApplicationsController < ApplicationController
    def index
        search_query = params[:search]
        if search_query.present?
            @applications = get_filtered_applications(search_query)
        else
            @applications = get_applications            
        end
    end

    def show
        @application = Application.includes(interviews: :feedback).find(params[:id])
        @interviews = @application.interviews
        @round_topics = Interview::ROUND_TOPICS
    end

    def update_status
        @application = Application.find_by(id: params[:id])
        if @application.update_attributes(application_params)
            @application.send_application_status_mail(current_user)
            flash[:success] = "Application Status Updated"
            redirect_to @application
        else
            flash[:danger] = "Failed to update"
            redirect_to @application
        end
    end

    def edit
        @application = Application.find_by(id: params[:id])
    end

    def update
        @application = Application.find_by(id: params[:id])
        @application.candidate_id = params[:candidate_id]
        if @application.update_attributes(application_params)
            flash[:success] = "Application Updated"
            redirect_to @application
        else
            redirect_to edit_candidate_application_path(id: @application.id, candidate_id: @application.candidate_id), flash: { danger: @application.errors.full_messages.join(', ') }
        end
    end

=begin
    # Deprecate
    def show_application_interview
        @application = Application.find(params[:id])
        @interviews = @application.interviews.order(:created_at)
        @interview = @interviews.find_by(id: params[:interview_id])
        @comments = @interview.feedback
    end
=end

    private
        def application_params
            params.require(:application).permit(:status, :search, :role, :experience, :resume)
        end

        def get_applications
            if is_manager?(current_user)
                @applications = Application.eager_load(:candidate).paginate(page: params[:page], per_page: 10)            
            else
                @applications = current_user.involved_applications.eager_load(:candidate).paginate(page: params[:page], per_page: 10)            
            end
        end

        def get_filtered_applications(search_query)
            conditions = 'candidates.name LIKE :query OR candidates.email LIKE :query'\
                         ' OR applications.experience LIKE :query OR applications.role LIKE :query'\
                         ' OR applications.status LIKE :query'
            if is_manager?(current_user)
                @applications = Application.eager_load(:candidate).where(conditions, query: "%#{search_query}%").paginate(page: params[:page], per_page: 10)
            else
                @applications = current_user.involved_applications.eager_load(:candidate).where(conditions, query: "%#{search_query}%").paginate(page: params[:page], per_page: 10)
            end
        end
end
