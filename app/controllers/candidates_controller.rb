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
        @candidate = Candidate.find_by(email: params[:candidate][:email])
        if @candidate.nil?
            create_candidate_and_application
        else
            attach_application_to_existing_candidate
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

        def create_candidate_and_application
            @candidate = Candidate.new(candidate_application_params)
            # Assign current user as the owner of the application
            @candidate.applications.first.assign_owner_id(current_user.id)
            if @candidate.save
                flash[:success] = "Candidate and application created"
                redirect_to applications_path
            else
                render 'new_application_for_candidate'
            end
        end

        def attach_application_to_existing_candidate
            application_params = candidate_application_params[:applications_attributes]["0"]
            application = @candidate.applications.build(application_params)
            application.assign_owner_id(current_user.id)
            if application.save
                flash[:success] = "New application added to existing candidate with #{@candidate.email} email."
                redirect_to applications_path
            else
                render 'new_application_for_candidate'
            end
        end
end
