require 'google_calendar_wrapper'
class NewEventController < GoogleController
    protected
    include RestGraph::RailsUtil
    before_filter :login_facebook, :only => [:login]
    before_filter :load_facebook, :except => [:login]
    before_filter :set_cal_client
    def set_cal_client
        @cal_wrapper = GoogleCalendarWrapper.new(@client)
    end
    public
    def new
        if @redirected
            return
        end
        @o = Organization.all
    end
    def done
        @event_name = params[:event_name]
        @start = params[:event_start]   
        @end = params[:event_end]
        @start_date = @start["event_start(1i)"] .concat("-").concat(@start["event_start(2i)"]).concat("-").concat(@start["event_start(3i)"])
        @end_date = @end["event_end(1i)"] .concat("-").concat(@end["event_end(2i)"]).concat("-").concat(@end["event_end(3i)"])
        @org = params[:org]
        if @org == "1" #exist
            @org_name = params[:org_name]
            @org_id = Organization.where(:org_name => @org_name).first.id
        else #not exist
            @org_name_new = params[:org_name_new]
            @o_new = Organization.new(:org_name => @org_name_new)
            @o_new.save
            @org_name = @o_new.org_name
            @org_id = @o_new.id
        end         
        if session[:user_id] == nil
            @me = rest_graph.get('/me')
            @u = User.new
            @u.username = @me["name"]
            @u.fb_id = @me["id"]
            @u.email = @me["email"]
            @u.save
            session[:user_id] = @u.id
        end         

        cal_id = @cal_wrapper.create_cal(params[:event_name])[:cal].id


        @e = Event.new(:event_name => @event_name, :event_start => @start_date, :event_end => @end_date, :event_head => session[:user_id],:organization_id=> @org_id, :accounting_manager_id => session[:user_id], :calendar_id => cal_id)
        if ! @e.save
            render :text => "create event fail", :status => 400
            return
        end
        @a = UserEvent.new(:user_id => session[:user_id], :event_id => @e.id)
        if ! @a.save
            render :text => "create user event fail", :status => 400
            return
        end
        redirect_to home_path
    end

    private
    def login_facebook
        reset_session

        rest_graph_setup(:auto_authorize => true,
                         :auto_authorize_scope => 'email',
                         :ensure_authorized => true,
                         :write_session => true )
    end
    def load_facebook
        rest_graph_setup(:write_session => true)
    end
end
