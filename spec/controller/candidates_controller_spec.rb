require "rails_helper"

RSpec.describe CandidatesController, type: :controller do
    let!(:test_candidate) { FactoryBot.create(:candidate) }

    before do
        employee = FactoryBot.create(:employee)
        log_in_as(employee)
    end
    
    describe 'POST :create' do
        let(:candidate_params) { { candidate: FactoryBot.attributes_for(:candidate) } }

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

    describe 'POST :create_application_for_candidate' do
=begin
        Params structure:
        {
            candidate: {
                ---,
                ---,
                applications_attributes: {
                    '0': {
                        ----,
                        ----
                    }
                }
            }
        }
=end
        let(:candidate_application_params) {
            params = {}
            params[:candidate] = FactoryBot.attributes_for(:candidate)
            params[:candidate][:applications_attributes] = {}
            params[:candidate][:applications_attributes]["0"] = FactoryBot.attributes_for(:application)
            return params
        }

        it "adds application for existing candidate" do
            candidate_application_params[:candidate][:email] = test_candidate.email
            expect do
                post :create_application_for_candidate, params: candidate_application_params
            end.to change { test_candidate.reload.applications.size }.by(1)
            .and change { Candidate.count }.by(0)
        end

        it "creates new candidate and new application" do
            expect do
                post :create_application_for_candidate, params: candidate_application_params
            end.to change { Application.count }.by(1)
            .and change { Candidate.count }.by(1)
        end

        it "does not change name when new application is submitted" do
            candidate_application_params[:candidate][:email] = test_candidate.email
            test_candidate_old_name = test_candidate.name
            candidate_application_params[:candidate][:name] = "New name"
            expect do
                post :create_application_for_candidate, params: candidate_application_params
            end.to change { test_candidate.reload.applications.size }.by(1)
            expect(test_candidate.name).to eq(test_candidate_old_name) 
        end
    end
end