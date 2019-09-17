module GoogleService
    module Events
        extend self

        def build_interview_schedule_event(interview)
            event = Google::Apis::CalendarV3::Event.new({ 
                summary: 'Interview at Beautifulcode',
                description: 'You are having an interview at Beautifulcode',
                timeZone: 'Asia/Kolkata',
                start: {
                    date_time: interview.start_time.in_time_zone("Kolkata").rfc3339,
                    time_zone: 'Asia/Kolkata'
                },
                end: {
                    date_time: interview.end_time.in_time_zone("Kolkata").rfc3339,
                    time_zone: 'Asia/Kolkata'
                },
                attendees: get_interview_attendees_hash(interview),
                reminders: {
                    use_default: true,
                }
            })
        end

        def update_interview_event(event, interview)
            event.start = {
                date_time: interview.start_time.rfc3339,
                time_zone: 'Asia/Kolkata'
            }

            event.end = {
                date_time: interview.end_time.rfc3339,
                time_zone: 'Asia/Kolkata'
            }

            event.attendees = get_interview_attendees_hash(interview)
            event
        end

        private
            def get_interview_attendees_hash(interview)
                attendees = []
                attendees << interview.interviewer.email
                attendees << interview.application.candidate.email
                
                attendees = attendees.map { |email| {email: email} }
            end
    end
end