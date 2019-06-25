require "rails_helper"

RSpec.describe Interview, type: :model do
    let(:interview_one) { FactoryBot.build_stubbed(:interview) }
    let(:time) { Time.new }

    it "is valid with valid attributes" do
        expect(interview_one).to be_valid
    end

    context "is not valid without" do
        it "round name" do
            interview_one.round_name = " "
            expect(interview_one).to_not be_valid
        end
    
        it "start time" do 
            interview_one.start_time = " "
            expect(interview_one).to_not be_valid
        end
    
        it "end time" do
            interview_one.end_time = " "
            expect(interview_one).to_not be_valid
        end
    
        it "date" do
            interview_one.scheduled_on = "invalid_date"
            expect(interview_one).to_not be_valid
        end
    end

    context "timeslot raises exception" do
        it "if start and end time are same" do
            interview = FactoryBot.build(:interview, start_time: time, end_time: time)
            expect { interview.save }.to raise_error(Exceptions::InvalidTimeSlotException)
        end

        it "if end time is earlier than start time" do
            end_time = time - 60*60
            interview = FactoryBot.build(:interview, start_time: time, end_time: end_time)
            expect { interview.save }.to raise_error(Exceptions::InvalidTimeSlotException)
        end
    end
end