class CalendarController < GoogleController
    def default
        ## Persist the token here
    end

    def oauth2authorize
        redirect_to @client.authorization.authorization_uri.to_s
    end

    def oauth2callback
        @client.authorization.fetch_access_token!
        #file = @drive_api.files.insert.request_schema.new({
        #    :title => 'Test file'
        #    :description => 'YAYA'
        #})

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
