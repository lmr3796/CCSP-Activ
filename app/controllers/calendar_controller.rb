require 'google_calendar_wrapper'

class CalendarController < GoogleController
    protected
    before_filter :set_cal_client
    def set_cal_client
        @cal_wrapper = GoogleCalendarWrapper.new(@client)
    end
    public
    def cal
        result = @cal_wrapper.create_cal(params[:name])
        if result[:cal].id and result[:acl].id
            render :text => result[:cal].id
        elsif not result[:cal].id
            render :json => { :message => "Failed to create calendar" }, :status => 404
        elsif not result[:acl].id
            render :json => { :message => "Failed setting of access rights" }, :status => 404
        end
    end
end
