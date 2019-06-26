require "rails_helper"

RSpec.describe CandidatesController, type: :controller do
    let(:candidate_params) { { candidate: FactoryBot.attributes_for(:candidate) } }
    let(:test_candidate) { FactoryBot.create(:candidate) }
    
    before do
        employee = FactoryBot.create(:employee)
        log_in_as(employee)
    end
    
    describe 'POST :create' do
        it "saves candidate for valid payload" do
            expect do 
                post :create, params: candidate_params
            end.to change { Candidate.count }.by(1)
            expect(Candidate.find_by(email: candidate_params[:candidate][:email])).to_not be_nil
        end

        it "redirects to candidates path on success" do
            post :create, params: candidate_params
            expect(Candidate.find_by(email: candidate_params[:candidate][:email])).to_not be_nil
            expect(response).to redirect_to(candidates_path)
        end

        it "redirects to new page on failure" do
            candidate_params[:candidate][:email] = nil
            invalid_candidate_params = candidate_params
            post :create, params: candidate_params
            expect(assigns(:candidate).errors.present?).to eq(true)
            expect(response).to render_template(:new)
        end
    end

    describe 'GET :show' do
        it "shows the candidate" do
            get :show, params: {id: test_candidate.id}
            expect(assigns(:candidate).id).to eq(test_candidate.id)
            expect(response).to have_http_status(200)
            expect(response).to render_template(:show)
        end
    end

    describe 'GET :index' do
        it "shows index page" do
            get :index
            expect(response).to have_http_status(200)
            expect(response).to render_template(:index)
        end
    end
end