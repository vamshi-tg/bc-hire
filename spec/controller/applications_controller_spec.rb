require "rails_helper"

RSpec.describe ApplicationsController, type: :controller do

    context "when manager logs in" do
        let(:manager_one) { FactoryBot.create(:employee, manager: true) } 
        before do
            log_in_as(manager_one)
        end

        describe "GET :index" do
            it "retrieves all the applications" do
                manager_one_applications = FactoryBot.create_list(:application, 5, owner: manager_one)
                get :index
                expect(assigns(:applications).size).to eq(manager_one_applications.size)
            end
        end
    end

    context "when interviewer logs in" do
        let(:interviewer_one) { FactoryBot.create(:employee) }
        before do
            log_in_as(interviewer_one)
        end

        describe "GET :index" do
            it "retrieves only the associated applications" do
                FactoryBot.create_list(:interview, 3,interviewer: interviewer_one)
                get :index
                expect(assigns(:applications).size).to eq(interviewer_one.involved_applications.size)
            end
        end
    end
end