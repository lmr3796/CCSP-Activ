require 'google_calendar_wrapper'

class CalendarController < GoogleController
    protected
    before_filter :set_cal_client
    def set_cal_client
        @cal_wrapper = GoogleCalendarWrapper.new(@client)
    end
    public
    def create_cal
        if @redirected
            return
        end
        result = @cal_wrapper.create_cal(params[:title], params[:email])
        if result[:cal].id
            session[:calendar_id] = result[:cal].id
            if result[:public].id and result[:boss].id
                render :text => result[:cal].id
                #render :json => result[:cal]
            else
                render :json => { :message => "Failed setting of access rights" }, :status => 404
            end
        else
            render :json => { :message => "Failed to create calendar" }, :status => 404
        end
    end

    def create_acl
        if @redirected
            return
        end
        result = @cal_wrapper.create_acl(params[:cal_id], params[:email])
        render :json => result.data, :status => result.status
    end

    def delete_acl
        if @redirected
            return
        end
        result = @cal_wrapper.delete_acl(params[:cal_id], params[:email])
        if result.blank?
            render :json => result
        else
            render :json => {:failed_id => result} , :status => 400
        end
    end
end
