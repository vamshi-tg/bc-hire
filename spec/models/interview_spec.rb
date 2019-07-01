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

    describe "#prepend_scheduled_date_to_time" do
        context "when schedule_on is present" do
            it 'should prepend schedule_on to start and end time' do  
                interview_one.send(:prepend_scheduled_date_to_time)
                expect(interview_one.start_time.to_date).to eq(interview_one.scheduled_on)
                expect(interview_one.end_time.to_date).to eq(interview_one.scheduled_on)
            end

            it "should convert time to IST timezone" do
                TIME_FORMAT = "%I:%M %p"
                
                interview = FactoryBot.build(:interview)
                start_time_before = interview.start_time.strftime(TIME_FORMAT)
                end_time_before = interview.end_time.strftime(TIME_FORMAT)
                
                interview.send(:prepend_scheduled_date_to_time)
                
                start_time_after = interview.start_time.in_time_zone("Kolkata").strftime(TIME_FORMAT)
                end_time_after = interview.end_time.in_time_zone("Kolkata").strftime(TIME_FORMAT)

                expect(start_time_before).to eq(start_time_after)
                expect(end_time_before).to eq(end_time_after)
            end
        end
    end
end