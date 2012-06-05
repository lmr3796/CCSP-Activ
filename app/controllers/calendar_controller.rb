require 'google_calendar_wrapper'

class CalendarController < GoogleController
    protected
    before_filter :set_cal_client
    def set_cal_client
        @cal_wrapper = GoogleCalendarWrapper.new(@client)
    end
    public
    def cal
        render :json => @cal_wrapper.create_cal(params[:name])
    end
end
