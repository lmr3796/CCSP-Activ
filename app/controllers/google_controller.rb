require 'json'
require 'google/api_client'

class GoogleTokenPair
    attr_accessor :refresh_token, :access_token, :expires_in, :issued_at

    def initialize(object=nil)
        if object
            self.update_token!(object)
        end
    end

    def update_token!(object)
        if object.class == Signet::OAuth2::Client
            @refresh_token  = object.refresh_token
            @access_token   = object.access_token
            @expires_in     = object.expires_in
            @issued_at      = object.issued_at
        elsif object.class == Hash
            @refresh_token  = object[:refresh_token]
            @access_token   = object[:access_token]
            @expires_in     = object[:expires_in]
            @issued_at      = object[:issued_at]
        end
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

class GoogleController < ApplicationController
    attr_accessor :client, :drive_api, :cal_api
    #Constants
    CLIENT_ID = '750890957735.apps.googleusercontent.com'
    CLIENT_SECRET = 'Z8h9EIp5NJrG7BWOQYcGNXgC'
    REDIRECT_CALLBACK = '/oauth2callback'
    API_SCOPES = [
        'https://www.googleapis.com/auth/calendar',
        'https://www.googleapis.com/auth/drive.file'
    ]
    protected
    before_filter :set_google_client
    def set_google_client
        # get api_path and redirect uri
        /^(?<api_path>\/[^\/]*)/ =~ request.path_info
        redirect_uri = root_url[0...-1] + api_path + REDIRECT_CALLBACK
        @client = Google::APIClient.new
        @client.authorization.client_id = CLIENT_ID
        @client.authorization.client_secret = CLIENT_SECRET
        @client.authorization.scope = API_SCOPES
        @client.authorization.redirect_uri = redirect_uri
        @client.authorization.code = params[:code] if params[:code]
        if session[:google_token]
            # Load the access token here if it's available
            token_pair = GoogleTokenPair.new(session[:google_token])
            @client.authorization.update_token!(token_pair.to_hash)
        end
        if @client.authorization.refresh_token && @client.authorization.expired?
            @client.authorization.fetch_access_token!
        end
        unless @client.authorization.access_token || request.path_info =~ /\/oauth2/
            redirect_to  api_path + '/oauth2authorize'
        end
        if request.path_info =~ /\/oauth2callback$/
            persist_token()
        end
    end

    protected
    def persist_token
        @client.authorization.fetch_access_token!
        token_pair = if session[:google_token]
                         GoogleTokenPair.new(session[:google_token])
                     else
                         GoogleTokenPair.new
                     end
        token_pair.update_token!(@client.authorization)
        session[:google_token] = token_pair.to_hash
    end

    public
    def default
        ## Persist the token here
    end

    def oauth2authorize
        redirect_to @client.authorization.authorization_uri.to_s
    end

    def oauth2callback
    end
end
