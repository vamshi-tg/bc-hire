class CandidatesController < ApplicationController 
    def new
        @candidate = Candidate.new
        @candidate.applications.build
    end

    def create
        @candidate = Candidate.new(candidate_params)
        if @candidate.save
            flash[:success] = "Candidate Created"
            redirect_to candidates_path
        else
            render 'new'
        end
    end

    def index
        @candidates = Candidate.paginate(page: params[:page], per_page: 10)
    end

    def show
        @candidate = Candidate.find(params[:id])
    end

    def edit
        @candidate = Candidate.find(params[:id])
    end

    def update
        @candidate = Candidate.find(params[:id])
        if @candidate.update_attributes(candidate_params)
            redirect_to candidates_path
        else
            render 'edit'
        end
    end

    def new_application_for_candidate
        @candidate = Candidate.new
        @candidate.applications.build
    end

    def create_application_for_candidate
        result = Application.create_application(candidate_application_params, current_user)
        if result[:is_created]
            flash[:success] = result[:message]
            redirect_to applications_path
        else
            render 'new_application_for_candidate'
        end
    end

    private
        def candidate_params
            params.require(:candidate).permit(:name, :email)
        end

        def candidate_application_params
            params.require(:candidate).permit(:name, :email,
                applications_attributes: [:id, :experience, :role, :resume]
            )
        end
end
