class HomeController < ApplicationController
  include RestGraph::RailsUtil
  before_filter :login_facebook

  def index
	@access_token = rest_graph.access_token
	if @access_token
		@me = rest_graph.get('/me')
		@email = @me["email"]
		@u = User.where(:email => @email).first
		if @u == nil
			@u2 = User.new(:username => @me["name"], :email => @email, :fb_id => @me["id"])
			@u2.save
			@user = @u2
			@type = 1 #new
			
		else
			@type = 2 #old
			if(@u.username == nil)	
				@u.username = @me["name"]
				@u.fb_id = @me["id"]
				@u.save
				@type = 1 #new
			end
			@user = @u
		end
		@events = @user.events #list events for user

	end
  end

  def event
	
  end
private
	def login_facebook
		rest_graph_setup(:auto_authorize => true,
				 :auto_authorize_scope => 'email',
				 :ensure_authorized => true,
				 :write_session => true )
	end
end
