require 'json'
require 'google/api_client'

class TokenPair
    attr_accessor :refresh_token, :access_token, :expires_in, :issued_at

    def update_token!(object)
        @refresh_token  = object.refresh_token
        @access_token   = object.access_token
        @expires_in     = object.expires_in
        @issued_at      = object.issued_at
    end

    def to_hash
        return {
            :refresh_token  => refresh_token,
            :access_token   => access_token,
            :expires_in     => expires_in,
            :issued_at      => Time.at(issued_at)
        }
    end
end

class CalendarController < ApplicationController
    #Constants
    CLIENT_ID = '750890957735.apps.googleusercontent.com'
    CLIENT_SECRET = 'Z8h9EIp5NJrG7BWOQYcGNXgC'
    REDIRECT_URI = 'http://localhost:3000/cal/oauth2callback'
    API_SCOPES = [
        'https://www.googleapis.com/auth/calendar',
        'https://www.googleapis.com/auth/drive.file'
    ]
    before_filter :set_google_calendar_client
    private
    def set_google_calendar_client
        @client = Google::APIClient.new
        @client.authorization.client_id = CLIENT_ID
        @client.authorization.client_secret = CLIENT_SECRET
        @client.authorization.scope = API_SCOPES
        @client.authorization.redirect_uri = REDIRECT_URI
        @client.authorization.code = params[:code] if params[:code]
        if session[:token_id]
            # Load the access token here if it's available
            @client.authorization.update_token!(token_pair.to_hash)
        end
        if @client.authorization.refresh_token && @client.authorization.expired?
            @client.authorization.fetch_access_token!
        end
        @calendar = @client.discovered_api('calendar', 'v3')
        unless @client.authorization.access_token || request.path_info =~ /\/oauth2/
            redirect_to '/cal/oauth2authorize'
        end
    end

    public
    def default
        ## Persist the token here
    end
    def oauth2authorize
        redirect_to @client.authorization.authorization_uri.to_s
    end

    def oauth2callback
        @client.authorization.fetch_access_token!
        result = @client.execute(:api_method => @calendar.events.list,
                                 :parameters => {'calendarId' => 'primary'})
        render :json => result.data.to_json
        #redirect_to '/cal'
    end
end
