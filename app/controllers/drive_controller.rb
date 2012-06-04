class CalendarController < GoogleController
    def oauth2callback
        @client.authorization.fetch_access_token!
        file = @drive_api.files.insert.request_schema.new({
            :title => 'Test file'
            :description => 'A test file for me to practice drive API'
        })

        render :json => result.data.to_json
    end
end
