require "rails_helper"

RSpec.describe CandidatesController, type: :controller do
    let(:candidate_params) { { candidate: FactoryBot.attributes_for(:candidate) } }

    before do
        employee = FactoryBot.create(:employee)
        log_in_as(employee)
    end
    
    describe 'POST :create' do
        it "should save candidate" do
            expect do 
                post :create, params: candidate_params
            end.to change { Candidate.count }.by(1)
            expect(Candidate.find_by(email: candidate_params[:candidate][:email])).to_not be_nil
        end
    end
end