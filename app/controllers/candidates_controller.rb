class CandidatesController < ApplicationController
    before_action :logged_in_user
    
    def new
        @candidate = Candidate.new
        @candidate.applications.build
    end

    # TODO-Complete this action. Currently not use
    def create
        @candidate = Candidate.new(candidate_params)
        if @candidate.save
            redirect_to candidates_path
        else
            
        end
    end

    def index
        @candidates = Candidate.all
        @candidates = Candidate.paginate(page: params[:page])
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
            redirect_to @candidate
        else
            render 'edit'
        end
    end

    def new_application_for_candidate
        @candidate = Candidate.new
        @candidate.applications.build
    end

    def create_application_for_candidate
        all_params = candidate_application_params
        @candidate = Candidate.find_by(email: all_params[:email])
        if @candidate.nil?
            create_candidate_and_application(all_params)
        else
            attach_application_to_existing_candidate(all_params)
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

        def create_candidate_and_application(all_params)
            @candidate = Candidate.new(all_params)
            if @candidate.save
                flash[:success] = "Candidate and application created"
                redirect_to candidates_path
            else
                render 'new_application_for_candidate'
            end
        end

        def attach_application_to_existing_candidate(all_params)
            if @candidate.applications.create(all_params[:applications_attributes]["0"])
                flash[:success] = "New application added to existing candidate with #{@candidate.email} email."
                redirect_to candidates_path
            else
                render 'new_application_for_candidate'
            end
        end
end
