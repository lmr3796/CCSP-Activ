require 'google_calendar_wrapper'

class CalendarController < GoogleController
    protected
    before_filter :set_cal_client
    def set_cal_client
        @cal_wrapper = GoogleCalendarWrapper.new(@client)
    end
    public
    def cal
        if @redirected
            return
        end

        result = @cal_wrapper.create_cal(params[:name], params[:email])
        if result[:cal].id
            session[:calendar_id] = result[:cal].id
            if result[:public].id and result[:boss].id
                render :text => result[:cal].id
            else
                render :json => { :message => "Failed setting of access rights" }, :status => 404
            end
        else
            render :json => { :message => "Failed to create calendar" }, :status => 404
        end
    end
end
