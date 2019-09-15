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

    describe "#send_interview_schedule_mail" do
        it "sends mail" do
            allow(InterviewMailer).to receive_message_chain(:interview_schedule, :deliver_now)

            interview = FactoryBot.build_stubbed(:interview)
            expect(InterviewMailer).to receive(:interview_schedule).with(interview).once
            expect(InterviewMailer).to receive_message_chain(:interview_schedule, :deliver_now)

            interview.send_interview_schedule_mail
        end
    end

    describe "#send_interview_schedule_update_mail" do
        it "sends mail" do
            allow(InterviewMailer).to receive_message_chain(:interview_schedule_update, :deliver_now)

            interview = FactoryBot.build_stubbed(:interview)
            triggerer = FactoryBot.build_stubbed(:employee)
            
            expect(InterviewMailer).to receive(:interview_schedule_update).with(interview, kind_of(Hash), triggerer).once
            expect(InterviewMailer).to receive_message_chain(:interview_schedule_update, :deliver_now)

            interview.send_interview_schedule_update_mail({email: ["old", "new"]}, triggerer)
        end
    end

    describe "uniquness validations for" do
        let(:interview_schedule) { { scheduled_on: "02-04-2019", start_time: "10:45 AM", end_time: "11:46 AM" } }
        let!(:candidate) { FactoryBot.create(:candidate) }
        let!(:application) { FactoryBot.create(:application, candidate: candidate)}
        let!(:interviewer) { FactoryBot.create(:interviewer) }
        let!(:interview) { interview = FactoryBot.create(:interview, { application: application, interviewer: interviewer }.merge(interview_schedule)) }

        it "application" do
            #different interviews for same application on same day and time slot
            interview_two = FactoryBot.build(:interview, {application: application}.merge(interview_schedule))
            expect(interview_two).to_not be_valid
            expect(interview_two.errors.messages[:application]).to eq(["already has an interview in this time slot"])
        end

        # it "interviewer" do
        #     dup_interview_for_interviewer = FactoryBot.build(:interview, { interviewer: interviewer }.merge(interview_schedule))
        #     expect(dup_interview_for_interviewer.valid?).to eq(false)
        # end
    end

    describe "#validate_interview_overlap" do
        let(:interview_date) { { scheduled_on: "02-04-2019" } }
        let(:start_time) { { start_time: "02-04-2019 10:00 AM"} }
        let(:end_time) { { end_time: "02-04-2019 11:00 AM"} }

        let(:interview_time_slot) {  start_time.merge(end_time) }
        let(:interview_schedule) { interview_date.merge(interview_time_slot) }

        let(:interviewer) { FactoryBot.create(:interviewer) }
        let!(:interview) { FactoryBot.create(:interview, { interviewer: interviewer }.merge(interview_schedule)) }

        context "does not raise exception when interviewer has interview" do
            it "on different date and same time" do
                expect do
                    interview_two = FactoryBot.build_stubbed(:interview, { interviewer: interviewer, scheduled_on: "03-04-2019", start_time: "03-04-2019 10:00 AM", end_time: "03-04-2019 11:00 AM"})
                    expect(interview_two).to be_valid
                end.to_not raise_error
            end

            it "on same date and different time" do
                expect do
                    interview_two = FactoryBot.build_stubbed(:interview, { interviewer: interviewer, start_time: "02-04-2019 12:00 PM", end_time: "02-04-2019 1:00 PM"}.merge(interview_date))
                    expect(interview_two).to be_valid
                end.to_not raise_error
            end

            it "on different date and different time" do
                expect do
                    interview_two = FactoryBot.build_stubbed(:interview, { interviewer: interviewer, scheduled_on: "04-04-2019",start_time: "04-04-2019 12:00 PM", end_time: "04-04-2019 1:00 PM" })
                    expect(interview_two).to be_valid
                end.to_not raise_error
            end
        end

        context "raises InterviewTimeOverlap Exception when interviewer has interview" do
            it "on same date and same time" do
                 expect do
                    FactoryBot.create(:interview, { interviewer: interviewer}.merge(interview_time_slot).merge(interview_date))
                 end.to raise_error(Exceptions::InterviewTimeOverlapException)
            end

            it "on same date and within same time slot" do
                expect do
                   FactoryBot.create(:interview, { interviewer: interviewer, start_time: "02-04-2019 10:20 AM", end_time: "02-04-2019 10:40 AM"}.merge(interview_date))
                end.to raise_error(Exceptions::InterviewTimeOverlapException)
            end

           it "on same date, same start_time and different end_time" do 
                expect do
                     FactoryBot.create(:interview, { interviewer: interviewer, end_time: "02-04-2019 11:30 AM"}.merge(start_time).merge(interview_date))
                end.to raise_error(Exceptions::InterviewTimeOverlapException)
            end

            it "on same date, different start_time and same end_time" do 
                expect do
                    FactoryBot.create(:interview, { interviewer: interviewer, start_time: "02-04-2019 9:30 AM"}.merge(end_time).merge(interview_date))
                end.to raise_error(Exceptions::InterviewTimeOverlapException)
            end

            # Should fix this use case
            # it "on same date scenario 1" do
            #     #interview two starts immediately after interview one
            #     expect do
            #         FactoryBot.create(:interview, { interviewer: interviewer, start_time: "11:00 AM", end_time: "12:00 PM"}.merge(interview_date))
            #     end.to raise_error(Exceptions::InterviewTimeOverlapException)
            # end

            it "on same date scenario 2" do
                #interview two starts immediately before interview one
                expect do
                    FactoryBot.create(:interview, { interviewer: interviewer, start_time: "02-04-2019 09:00 AM", end_time: "02-04-2019 10:00 AM"}.merge(interview_date))
                end.to raise_error(Exceptions::InterviewTimeOverlapException)
            end
        end
    end
end