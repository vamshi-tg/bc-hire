module GoogleService
    module Events
        extend self

        def build_interview_schedule_event(interview)
            event = Google::Apis::CalendarV3::Event.new({ 
                summary: get_interview_schedule_event_summary(interview),
                description: get_interview_schedule_event_description(interview),
                timeZone: 'Asia/Kolkata',
                start: {
                    date_time: interview.start_time.rfc3339,
                    time_zone: 'Asia/Kolkata'
                },
                end: {
                    date_time: interview.end_time.rfc3339,
                    time_zone: 'Asia/Kolkata'
                },
                attendees: get_interview_attendees_hash(interview),
                reminders: {
                    use_default: true,
                }
            })
        end

        def update_interview_event(event, interview)
            event.description = get_interview_schedule_event_description(interview)
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

            def get_interview_schedule_event_summary(interview)
                candidate_name = interview.application.candidate.name
                "#{candidate_name}'s Interview - #{interview.round_name.titleize}"
            end

            def get_interview_schedule_event_description(interview)
                resume_url = interview.application.resume.url 
                candidate_name = interview.application.candidate.name
                
                if resume_url.present?
                    resume_link = "<a href='#{resume_url}'> #{candidate_name}\'s Resume </a>"
                else
                    resume_link = "Not Available"
                end
                description = "Resume: #{resume_link}\n\nNote: Request candidates to join the call 10mins prior."
            end
    end
end