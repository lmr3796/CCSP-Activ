class HomeController < ApplicationController
  include RestGraph::RailsUtil
  #before_filter :login_facebook, :only => [:index]
  before_filter :login_facebook, :only => [:login]
  before_filter :load_facebook, :except => [:login]


  def index
	@access_token = rest_graph.access_token
	if @access_token
		@me = rest_graph.get('/me')
		@email = @me["email"]
		@u = User.where(:email => @email).first
		if @u == nil
			#@u2 = User.new(:username => @me["name"], :email => @email, :fb_id => @me["id"])
			#@u2.save
			#@user = @u2
			@type = 1 #new
			
		else
			@type = 2 #old
			if(@u.username == nil)	
				@u.username = @me["name"]
				@u.fb_id = @me["id"]
				@u.save
			end
			@user = @u
			session[:user_id] = @user.id
			@events = @user.events #list events for user
		end
	end
  end
  def login
       redirect_to home_path
  end


  def create_event
	@o = Organization.all
  end
  def create_event_done
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
	@e = Event.new(:event_name => @event_name, :event_start => @start_date, :event_end => @end_date, :event_head => session[:user_id],:organization_id=> @org_id)
	@e.save
	@a = UserEvent.new(:user_id => session[:user_id], :event_id => @e.id)
	@a.save
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
