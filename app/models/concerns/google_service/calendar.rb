# frozen_string_literal: true

module GoogleService
  module Calendar
    extend ActiveSupport::Concern

    def create_calendar_event(current_user)
      begin
        event = GoogleService::Events.build_interview_schedule_event(self)
        response = calendar_client(current_user).create(event)

        if response[:event]
          self.update_attribute(:google_event_id, response[:event].id)
        else
          logger.error "#{response[:err].exception.message}"
        end
      rescue StandardError => e
        logger.error "Error while creating calendar event: #{e.message} - #{e.backtrace.inspect}"
      end
    end

    def update_calendar_event(current_user)
      begin
        response = calendar_client(current_user).get(self.google_event_id)
        existing_event = response[:event]

        if existing_event
          event = GoogleService::Events.update_interview_event(existing_event, self)
          update_response = calendar_client(current_user).update(event)
          logger.error "#{update_response[:err].exception.message}" if update_response[:err]
        else
          logger.error "#{response[:err].exception.message}"
        end
      rescue StandardError => e
        logger.error "Error while updating calendar event: #{e.message} - #{e.backtrace.inspect}"
      end
    end
    
    private
      def calendar_client(employee)
        @calendar_client ||= GoogleService::CalendarClient.new(employee)
      end
  end  
end
