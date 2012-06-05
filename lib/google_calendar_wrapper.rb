require 'google/api_client'
class GoogleCalendarWrapper
    attr_accessor :client

    public
    def initialize(client)
        @client = client
        @service = @client.discovered_api('calendar', 'v3')
    end

    def create_list(calendar_id)
        result = @client.execute(:api_method => @service.calendar_list.insert,
                                 :body_object => {:id => calendar_id})
        return result
    end

    def create_cal(summary)
        cal = @client.execute(:api_method => @service.calendars.insert,
                                :body_object => {:summary => summary})
        puts cal.data.id
        rule = {:scope => {:type => 'default', :value => ''},
                :role => 'reader'}
        acl = @client.execute(:api_method => @service.acl.insert,
                             :parameters => {'calendarId' => cal.data.id},
                             :body_object => rule)
        return {:cal => cal.data, :acl => acl.data} 
    end

    def get_cal

        return result
    end

    def get_list

        return result
    end

end
