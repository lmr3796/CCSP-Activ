class DriveController < GoogleController
    FILE_NAME = '/home/lmr3796/Downloads/NCCU_OOP.doc'
    def insert_file(arg={})
        title       = arg[:title]
        description = arg[:description]
        file_name   = arg[:file_name]
        mime_type   = arg[:mime_type]
        parent_id   = arg[:parent_id]

        file = @drive_api.files.insert.request_schema.new({
            'title' => title,
            'description' => description,
            'mimeType' => mime_type
        })
        # Set the parent folder.
        if parent_id
            file.parents_collection = [{'id' => parent_id}]
        end
        media = Google::APIClient::UploadIO.new(file_name, mime_type)
        result = @client.execute(
            :api_method => @drive_api.files.insert,
            :body_object => file,
            :media => media,
            :parameters => {'uploadType' => 'multipart', 'alt' => 'json'}
        )
        return result
    end
    def oauth2callback
        persist_token()
        @drive_api = @client.discovered_api('drive', 'v1')
        result = insert_file(:file_name => FILE_NAME, 
                             :title => "Test Test", 
                             :description => "Jizz", 
                             :mime_type => "application/msword")
        render :json => result.data.to_json
    end
end
