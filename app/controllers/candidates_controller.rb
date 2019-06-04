class CandidatesController < ApplicationController
    def new
        @candidate = Candidate.new
    end

    def create
        @candidate
        if @candidat.save
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

    private
        def candidate_params
            params.require(:candidate).permit(:name, :email, :experience)
        end
end
