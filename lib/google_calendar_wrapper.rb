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

    def create_cal(summary, boss_email)
        cal = @client.execute(:api_method => @service.calendars.insert,
                              :body_object => {:summary => summary})

        rule = {:scope => {:type => 'default', :value => ''},
                :role => 'reader'}
        acl_public = @client.execute(:api_method => @service.acl.insert,
                                     :parameters => {'calendarId' => cal.data.id},
                                     :body_object => rule)

        rule = {:scope => {:type => 'user', :value => boss_email},
                :role => 'owner'}
        acl_boss = @client.execute(:api_method => @service.acl.insert,
                                   :parameters => {'calendarId' => cal.data.id},
                                   :body_object => rule)
        return {:cal => cal.data, :public => acl_public.data, :boss => acl_boss.data} 
    end

    def delete_acl(calendar_id, email)
        acl_list = client.execute(:api_method => @service.acl.list,
                                  :parameters => {'calendarId' => calendar_id}).data.items
        id = acl_list.collect{|x| x.id if x.scope.type == "user" and x.scope.value == email}.compact
        result = id.collect{|rule_id| rule_id if client.execute(:api_method => @service.acl.delete,
                                                                :parameters => {:calendarId => calendar_id, 
                                                                     :ruleId => rule_id}).status != 204
                 }.compact
        return result
    end
end
