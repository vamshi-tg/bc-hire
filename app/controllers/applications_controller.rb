class ApplicationsController < ApplicationController
    def new
        @application = Application.new
    end

    def create
        all_params = candidate_application_params
        @candidate = Candidate.find_by(email: params['candidate']['email'])

        if @candidate
            create_candidate_application(all_params['candidate'], @candidate)
        else
            new_candidate = create_user(all_params['candidate'])
            create_candidate_application(all_params['candidate'], new_candidate)
        end
    end

    def index
        
    end

    private
        def candidate_application_params
            all_params = {}
            all_params['candidate'] = params.require(:application).permit(:name, :email)
            all_params['applicaton'] = params.require(:application).permit(:role, :experience)
        end

        def create_candidate_application(params, candidate)
            if candidate.applications.create(all_params['application'])

            else

            end
        end

        def create_user(params)
            @new_candidate = User.new(params)
            if @new_candidate.save
                return @new_candidate
            else
                return nil
            end
        end
end
