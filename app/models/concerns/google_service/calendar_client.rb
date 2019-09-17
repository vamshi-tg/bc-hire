module GoogleService
    class CalendarClient
        CALENDAR_ID = 'primary'

        def initialize(employee)
            @client = init_client(employee)
        end

        def create(event)
            response = {}
            @client.insert_event(CALENDAR_ID, event, send_updates: "all") do |result, err|
              response[:event] = result
              response[:err] = err
            end
            response
        end
    
        def update(event)
            response = {}
            @client.update_event(CALENDAR_ID, event.id, event, send_updates: "all") do |result, err|
              response[:event] = result
              response[:err] = err
            end
            response
        end
    
        def get(event_id)
            response = {}
            @client.get_event(CALENDAR_ID, event_id) do |result, err|
              response[:event] = result
              response[:err] = err
            end
            response
        end

        private
            def init_client(employee)
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
                  logger.error "Error while creating google calendar client: #{e.message}"
                end
        
                client 
            end
    end
end