# frozen_string_literal: true

module GoogleService
  module Calendar
    extend ActiveSupport::Concern

    CALENDAR_ID = 'primary'
  
    def create_calendar_event(current_user)
      begin
        event = GoogleService::Events.build_interview_schedule_event(self)
        response = create(event, current_user)

        if response[:event]
          #To update google event id
          self.update_attributes(google_event_id: response[:event].id)
        else
          # Handle error
          #puts response[:err].exception.message
        end
  
      rescue => e
        p e.message
        p e.backtrace
      end
    end

    def update_calendar_event(current_user)
      begin
        event_id = self.google_event_id
        event = get(event_id, current_user)

        event.start = {
          date_time: self.start_time.rfc3339,
          time_zone: 'Asia/Kolkata'
        }
      
        event.end = {
          date_time: self.end_time.rfc3339,
          time_zone: 'Asia/Kolkata'
        }

        attendees = []
        attendees << self.interviewer.email
        attendees << self.application.candidate.email
        attendees = attendees.map { |email| {email: email} }

        event.attendees = attendees

        response = update(event, current_user)

        if response[:event]
          #To update google event id
          # self.update_attributes(google_event_id: response[:event].id)
        else
          # Handle error
          #puts response[:err].exception.message
        end
  
      rescue => e
        p e.message
        p e.backtrace
      end
    end
    
    private
      def create(event, employee)
        response = {}
        client = get_google_calendar_client employee
        client.insert_event(CALENDAR_ID, event, send_updates: "all") do |result, err|
          response[:event] = result
          response[:err] = err
        end
        response
      end

      def update(event, employee)
        response = {}
        client = get_google_calendar_client employee
        client.update_event(CALENDAR_ID, event.id, event, send_updates: "all") do |result, err|
          response[:event] = result
          response[:err] = err
        end
        response
      end

      def get(event_id, employee)
        client = get_google_calendar_client employee
        event = client.get_event(CALENDAR_ID, event_id)
      end

      def get_google_calendar_client employee
        client = Google::Apis::CalendarV3::CalendarService.new

        secrets = Google::APIClient::ClientSecrets.new({
          "web" => {
            "access_token" => employee.google_token,
            "refresh_token" => employee.refresh_token,
            "client_id" => Rails.application.secrets.google_client_id,
            "client_secret" => Rails.application.secrets.google_client_secret,
          }
        })
  
        begin
          client.authorization = secrets.to_authorization
          client.authorization.grant_type = "refresh_token"
  
          if employee.google_token_expired?
            client.authorization.refresh!
            employee.update_attributes(
              google_token: client.authorization.access_token,
              refresh_token: client.authorization.refresh_token,
              google_token_expires_at: client.authorization.expires_at.to_i
            )
          end
        rescue => e
          raise e.message
        end

        client    
      end
  end  
end
