class EventController < ApplicationController
  before_filter :set_some_session_variable

  def set_some_session_variable
	@id = params[:id] || session[:id]
	@user_id = Integer(session[:user_id])
  end
  def index
	session[:id] = @id
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
  end
  def destroy
	@d_id = params[:d_id]
	@a = UserEvent.where(:user_id => @d_id, :event_id => @id).first
	@a.destroy
	redirect_to :action => :index
  end
  def destroy_depuser
	@d_id = params[:d_id]
	@dep_id = params[:dep_id]
	@d = UserDepartment.where(:user_id => @d_id, :department_id => @dep_id).first
	@d.destroy
	redirect_to :action => :index
  end
  def destroy_dep
	@d_id = params[:d_id]
	@d = Department.find(@d_id)
	@d.destroy
	@ds = UserDepartment.where(:department_id => @d_id)
	@ds.destroy_all
	redirect_to :action => :index
  end
  def destroy_actuser
	@d_id = params[:d_id]
	@act_id = params[:act_id]
	@a = UserActivity.where(:user_id => @d_id, :activity_id => @act_id).first
	@a.destroy
	redirect_to :action => :index
  end
  def destroy_act
	@d_id = params[:d_id]
	@a = Activity.find(@d_id)
	@a.destroy
	@as = UserActivity.where(:activity_id => @d_id)
	@as.destroy_all
	redirect_to :action => :index
  end
  def create
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		@u = User.new(:email => @email)
		@u.save
	end
	@t = UserEvent.where(:user_id => @u.id, :event_id => @id).first
	if @t != nil
		flash[:notice] = "user has already joined the event!\n"
	else
		@a = UserEvent.new(:user_id => @u.id, :event_id => @id)
		@a.save
	end
	redirect_to :action => :index
  end
  def create_depuser
	@dep_id = params[:dep_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "dep user must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "dep user must join the event first!\n"
		else
			@tt = UserDepartment.where(:user_id => @u.id, :department_id => @dep_id).first
			if @tt != nil
				flash[:notice] = "user has already joined the department!\n"
			else
				@a = UserDepartment.new(:user_id => @u.id, :department_id => @dep_id)
				@a.save
			end
		end
	end
	redirect_to :action => :index
  end
  def create_dep
	@dep_name = params[:dep_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "dep admin must join the event first!\n"
	else
		@dep_head = @u.id
		@d = Department.new(:dep_name => @dep_name, :dep_head => @dep_head, :event_id => @id)
		@d.save
		@a = UserDepartment.new(:user_id => @dep_head, :department_id => @d.id)
		@a.save
	end
	redirect_to :action => :index
  end
  def create_actuser
	@act_id = params[:act_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "act user must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "act user must join the event first!\n"
		else
			@tt = UserActivity.where(:user_id => @u.id, :activity_id => @act_id).first
			if @tt != nil
				flash[:notice] = "user has already joined the activity!\n"
			else
				@a = UserActivity.new(:user_id => @u.id, :activity_id => @act_id)
				@a.save
			end
		end
	end
	redirect_to :action => :index
  end
  def create_act
	@act_name = params[:act_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "act admin must join the event first!\n"
	else
		@act_head = @u.id
		@a = Activity.new(:act_name => @act_name, :act_head => @act_head, :event_id => @id)
		@a.save
		@a2 = UserActivity.new(:user_id => @act_head, :activity_id => @a.id)
		@a2.save
	end
	redirect_to :action => :index
  end
end
