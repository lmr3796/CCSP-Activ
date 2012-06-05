class CalendarController < GoogleController
    def oauth2callback
        cal = @cal_api.calendars.insert.request_schema.new
        cal.summary = "Jizz"
        # insert a new calendar
        result = @client.execute(:api_method => @cal_api.calendars.insert,
                                 :body_object => cal)

        # delete a specified calendar
        #result = @client.execute(:api_method => @cal_api.calendars.delete,
        #                         :parameters => {:calendarId => cal.id})

        # insert a new event
        render :json => result.data.to_json
    end
end
